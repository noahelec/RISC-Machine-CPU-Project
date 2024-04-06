`timescale 1ps / 1ps

module datapath_tb();

  // Testbench signals
  reg clk;
  reg [15:0] datapath_in;
  reg vsel;
  reg [2:0] writenum, readnum;
  reg write, loada, loadb, loadc, loads;
  reg asel, bsel;
  reg [1:0] shift, ALUop;
  wire [15:0] datapath_out;
  wire Z_out, N_out, V_out;

  // Error signal
  reg err = 0;

  // Instantiate the datapath
  datapath DUT (
    .clk(clk),
    .loada(loada),
    .loadb(loadb),
    .loadc(loadc),
    .loads(loads),
    .write(write),
    .asel(asel),
    .bsel(bsel),
    .shift(shift),
    .ALUop(ALUop),
    .vsel(vsel),
    .writenum(writenum),
    .readnum(readnum),
    .pc(16'b0), // PC not used in this testbench
    .sximm8(datapath_in),
    .sximm5(16'b0), // sximm5 not used in this testbench
    .mdata(16'b0), // mdata not used in this testbench
    .datapath_out(datapath_out),
    .Z_out(Z_out),
    .N_out(N_out),
    .V_out(V_out)
  );

  // Clock generation
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk; // 50MHz clock
  end

  // Reset and Initialization
  initial begin
    // Reset all inputs
    {vsel, writenum, readnum, write, loada, loadb, loadc, loads, asel, bsel, shift, ALUop} = 0;
    datapath_in = 0;
    test_addition(16'b1101000001010101, 3'b001);
    // Wait for a few cycles after reset
    #40;

    // Test Case 1: Testing Addition Operation
task test_addition;
begin
  $display("Testing Addition Operation");

  // Initialize inputs
  datapath_in = 16'd5; // Immediate value for addition
  vsel = 1; writenum = 3'b001; // Load R1 with 5
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  datapath_in = 16'd3; // Immediate value for addition
  vsel = 1; writenum = 3'b010; // Load R2 with 3
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  // Load R1 into A
  loada = 1; readnum = 3'b001;
  wait_clock_cycles(1); loada = 0;

  // Load R2 into B
  loadb = 1; readnum = 3'b010;
  wait_clock_cycles(1); loadb = 0;

  // Perform addition operation
  asel = 0; bsel = 0; ALUop = 2'b00; // Select ADD
  loadc = 1; wait_clock_cycles(1); loadc = 0;

  // Check output
  if (datapath_out !== 16'd8) begin
    report_error(16'd8, datapath_out);
  end else begin
    $display("Addition test passed.");
  end
end
endtask
 
// Test Case 2: Testing Subtraction Operation
task test_subtraction;
begin
  $display("Testing Subtraction Operation");

  // Initialize inputs
  datapath_in = 16'd10; // Immediate value for subtraction
  vsel = 1; writenum = 3'b001; // Load R1 with 10
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  datapath_in = 16'd7; // Immediate value for subtraction
  vsel = 1; writenum = 3'b010; // Load R2 with 7
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  // Load R1 into A
  loada = 1; readnum = 3'b001;
  wait_clock_cycles(1); loada = 0;

  // Load R2 into B
  loadb = 1; readnum = 3'b010;
  wait_clock_cycles(1); loadb = 0;

  // Perform subtraction operation
  asel = 0; bsel = 0; ALUop = 2'b01; // Select SUB
  loadc = 1; wait_clock_cycles(1); loadc = 0;

  // Check output
  if (datapath_out !== 16'd3) begin
    report_error(16'd3, datapath_out);
  end else begin
    $display("Subtraction test passed.");
  end
end
endtask

// Test Case 3: Testing AND Operation
task test_and;
begin
  $display("Testing AND Operation");

  // Initialize inputs
  // Load R1 with 0b1010 (10)
  datapath_in = 16'b1010; vsel = 1; writenum = 3'b001;
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  // Load R2 with 0b1100 (12)
  datapath_in = 16'b1100; vsel = 1; writenum = 3'b010;
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  // Load R1 into A
  loada = 1; readnum = 3'b001;
  wait_clock_cycles(1); loada = 0;

  // Load R2 into B
  loadb = 1; readnum = 3'b010;
  wait_clock_cycles(1); loadb = 0;

  // Perform AND operation
  asel = 0; bsel = 0; ALUop = 2'b10; // Select AND
  loadc = 1; wait_clock_cycles(1); loadc = 0;

  // Check output
  if (datapath_out !== 16'b1000) begin
    report_error(16'b1000, datapath_out);
  end else begin
    $display("AND test passed.");
  end
end
endtask

// Test Case 4: Testing NOT Operation with Flag Check
initial
begin
  $display("Testing NOT Operation with Flag Check");

  // Initialize inputs
  // Load R1 with 0xFFFF (all 1s)
  datapath_in = 16'hFFFF; vsel = 1; writenum = 3'b001;
  write = 1; wait_clock_cycles(1); write = 0; vsel = 0;

  // Load R1 into B (for NOT operation)
  loadb = 1; readnum = 3'b001;
  wait_clock_cycles(1); loadb = 0;

  // Perform NOT operation
  asel = 1; // Don't care for NOT operation
  bsel = 0; ALUop = 2'b11; // Select NOT
  loadc = 1; wait_clock_cycles(1); loadc = 0;

  // Check output and Z flag
  if (datapath_out !== 16'h0000 || Z_out !== 1'b1) begin
    report_error(16'h0000, datapath_out);
    $display("Flag Error: Expected Z_flag = 1, got %b", Z_out);
    err = 1;
  end else begin
    $display("NOT test passed with correct flag.");
  end
end
endtask

    // Finish the simulation
    if (!err) $display("All tests passed.");
    $stop;
  end

  // Utility task for error reporting
  task report_error(input [15:0] expected, actual);
    begin
      $display("Error: Expected %d, got %d", expected, actual);
      err = 1;
    end
  endtask

  // Utility task for a simple delay
  task wait_clock_cycles(input integer cycles);
    begin
      repeat (cycles) @(posedge clk);
    end
  endtask

endmodule
