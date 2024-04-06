`timescale 1ps / 1ps

module datapath_tb();

  // Testbench signals
  reg clk;
  reg [15:0] datapath_in;
  reg vsel;
  reg [2:0] writenum, readnum;
  reg write, loada, loadb;
  reg [1:0] shift, ALUop;
  reg asel, bsel, loadc, loads;
  wire [15:0] datapath_out;
  wire Z_out;

  // Error signal
  reg err = 0;

  // Instantiate the datapath with named port association
  datapath DUT (
    .clk(clk),
    .datapath_in(datapath_in),
    .vsel(vsel),
    .writenum(writenum),
    .write(write),
    .readnum(readnum),
    .loada(loada),
    .loadb(loadb),
    .shift(shift),
    .asel(asel),
    .bsel(bsel),
    .ALUop(ALUop),
    .loadc(loadc),
    .loads(loads),
    .datapath_out(datapath_out),
    .Z_out(Z_out)
  );

  // Clock generation
  initial begin
        clk <= 1'b1;
        forever #5 clk = ~clk;
    end

  // Test sequence
  initial begin
  
  // MOV R0, #7
    datapath_in = 16'd7; // Load the immediate value 7
    vsel = 1;
    writenum = 3'b000; // Selecting R0
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // MOV R1, #2
    datapath_in = 16'd2; // Load the immediate value 2
    vsel = 1;
    writenum = 3'b001; // Selecting R1
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // Prepare for ADD operation by loading values into A and B registers
    // Load R1 into A (to be added)
    loada = 1;
    readnum = 3'b001; // Selecting R1
    #20; // Wait for the clock edge
    loada = 0; // Disable load after data has been latched
    
    // Load R0 into B and apply the shift (to be added with shift)
    loadb = 1;
    readnum = 3'b000; // Selecting R0
    shift = 2'b01; // Applying LSL#1
    #20; // Wait for the clock edge
    loadb = 0; // Disable load after data has been latched

    
    // Perform the ADD operation (R2 = R1 + R0 << 1)
    asel = 0; // Selecting A register value
    bsel = 0; // Selecting shifted B register value
    ALUop = 2'b00; // Selecting ADD operation
    loadc = 1; // Enable load for result
    #20; // Wait for the clock edge
    loadc = 0; // Disable load after data has been latched
    
    // Store the result in R2
    vsel = 0;
    writenum = 3'b010; // Selecting R2
    write = 1; // Enable write
    #10; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    
    // Verify the result
    readnum = 3'b010; // Select R2 to read
    #20; // Wait for data to be read out
    if (datapath_out !== 16'd16) begin
      $display("Test failed: Expected 16, got %d", datapath_out);
      err = 1; // Set error if the output is not as expected
    end else begin
      $display("Test passed: Expected 16, got %d", datapath_out);
    end
    


    // MOV R0, #7
    datapath_in = 16'd7; // Load the immediate value 7
    vsel = 1;
    writenum = 3'b000; // Selecting R0
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // MOV R1, #2
    datapath_in = 16'd2; // Load the immediate value 2
    vsel = 1;
    writenum = 3'b001; // Selecting R1
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // Prepare for SUBTRACT operation by loading values into A and B registers
    // Load R1 into A (to be added)
    loadb = 1;
    readnum = 3'b001; // Selecting R1
    #20; // Wait for the clock edge
    loadb = 0; // Disable load after data has been latched
    
    // Load R0 into B and apply no shift
    loada = 1;
    readnum = 3'b000; // Selecting R0
    shift = 2'b00; // Applying no shift
    #20; // Wait for the clock edge
    loada = 0; // Disable load after data has been latched

    
    // Perform the SUBTRACT operation (R2 = R1 - R0)
    asel = 0; // Selecting A register value
    bsel = 0; // Selecting B register value
    ALUop = 2'b01; // Selecting SUBTRACT operation
    loadc = 1; // Enable load for result
    #20; // Wait for the clock edge
    loadc = 0; // Disable load after data has been latched
    
    // Store the result in R2
    vsel = 0;
    writenum = 3'b010; // Selecting R2
    write = 1; // Enable write
    #10; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    
    // Verify the result
    readnum = 3'b010; // Select R2 to read
    #20; // Wait for data to be read out
    if (datapath_out !== 16'd5) begin
      $display("Test failed: Expected 5, got %d", datapath_out);
      err = 1; // Set error if the output is not as expected
    end else begin
      $display("Test passed: Expected 5, got %d", datapath_out);
    end


    // MOV R0, #12
    datapath_in = 16'd12; // Load the immediate value 7
    vsel = 1;
    writenum = 3'b000; // Selecting R0
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // MOV R1, #7
    datapath_in = 16'd7; // Load the immediate value 2
    vsel = 1;
    writenum = 3'b001; // Selecting R1
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // Prepare for AND operation by loading values into A and B registers
    // Load R1 into A (to be added)
    loada = 1;
    readnum = 3'b001; // Selecting R1
    #20; // Wait for the clock edge
    loada = 0; // Disable load after data has been latched
    
    // Load R0 into B and apply the shift (to be added with shift)
    loadb = 1;
    readnum = 3'b000; // Selecting R0
    shift = 2'b10; // Applying LSR#1, MSB 0
    #20; // Wait for the clock edge
    loadb = 0; // Disable load after data has been latched

    
    // Perform the AND operation (R2 = R1 & R0 >> 1)
    asel = 0; // Selecting A register value
    bsel = 0; // Selecting shifted B register value
    ALUop = 2'b10; // Selecting AND operation
    loadc = 1; // Enable load for result
    #20; // Wait for the clock edge
    loadc = 0; // Disable load after data has been latched
    
    // Store the result in R2
    vsel = 0;
    writenum = 3'b010; // Selecting R2
    write = 1; // Enable write
    #10; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    
    // Verify the result
    readnum = 3'b010; // Select R2 to read
    #20; // Wait for data to be read out
    if (datapath_out !== 16'd6) begin
      $display("Test failed: Expected 6, got %d", datapath_out);
      err = 1; // Set error if the output is not as expected
    end else begin
      $display("Test passed: Expected 6, got %d", datapath_out);
    end

  // MOV R0, #-32765
    datapath_in = 16'b1000000000000011; // Load the value 
    vsel = 1;
    writenum = 3'b000; // Selecting R0
    write = 1; // Enable write
    #20; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // Load R0 into B and apply the shift (to be added with shift)
    loadb = 1;
    readnum = 3'b000; // Selecting R0
    shift = 2'b11; // Applying LSR#1, MSB copy of [15]
    #20; // Wait for the clock edge
    loadb = 0; // Disable load after data has been latched

    
    // Perform the NOT operation (R2 = !(R0 >> 1))
    bsel = 0; // Selecting shifted B register value
    ALUop = 2'b11; // Selecting NOT operation
    loadc = 1; // Enable load for result
    #20; // Wait for the clock edge
    loadc = 0; // Disable load after data has been latched
    
    // Store the result in R2
    vsel = 0;
    writenum = 3'b010; // Selecting R2
    write = 1; // Enable write
    #10; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    
    // Verify the result
    readnum = 3'b010; // Select R2 to read
    #20; // Wait for data to be read out
    if (datapath_out !== 16'b0011111111111110) begin
      $display("Test failed: Expected 16382, got %d", datapath_out);
      err = 1; // Set error if the output is not as expected
    end else begin
      $display("Test passed: Expected 16382, got %d", datapath_out);
    end


  // MOV R0, #-1 - testing zflag
    datapath_in = 16'd1; // Load the value 
    vsel = 1;
    writenum = 3'b000; // Selecting R0
    write = 1; // Enable write
    #5; // Wait for the clock edge
    write = 0; // Disable write after data has been latched
    vsel = 0;
    
    // Load R0 into B and apply the shift 
    loadb = 1;
    readnum = 3'b000; // Selecting R0
    shift = 2'b00; // Applying no shift
    #5; // Wait for the clock edge
    loadb = 0; // Disable load after data has been latched

    // Perform the NOT operation (R2 = !R0)
    bsel = 0; // Selecting shifted B register value
    ALUop = 2'b11; // Selecting NOT operation
    loads = 1; // Enable load for result
    #5; // Wait for the clock edge
    loads = 0; // Disable load after data has been latched
    
    // Verify the result
    readnum = 3'b010; // Select R2 to read
    #5; // Wait for data to be read out
    if (Z_out !== 16'd0) begin
      $display("Test failed: Expected 0, got %d", Z_out);
      err = 1; // Set error if the output is not as expected
    end else begin
      $display("Test passed: Expected 0, got %d", Z_out);
    end


  $stop;
  

  





    
    
  end

endmodule
