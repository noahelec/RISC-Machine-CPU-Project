`timescale 1ps / 1ps

module regfile_tb;

  // Inputs
  reg [15:0] data_in;
  reg [2:0] writenum;
  reg [2:0] readnum;
  reg write;
  reg clk;

  // Outputs
  wire [15:0] data_out;

  // Error signal
  reg err = 0;

  // Instantiate the Unit Under Test (DUT)
  regfile DUT (
    .data_in(data_in), 
    .writenum(writenum), 
    .write(write), 
    .readnum(readnum), 
    .clk(clk), 
    .data_out(data_out)
  );

  // Clock generation
  always #10 clk = !clk; // Generate a clock with a period of 20ns

  // Test sequence
  initial begin
    // Initialize Inputs
    data_in = 0;
    writenum = 0;
    readnum = 0;
    write = 0;
    clk = 0;

    // Wait for global reset
    #10;

    // Test Case 1: Write and read from register 0
    data_in = 16'd5; // Test data
    writenum = 3'b000; // Select register 0
    write = 1'b1; // Enable write
    #20; // Wait for a clock edge
    write = 1'b0; // Disable write
    readnum = 3'b000; // Select register 0 to read
    #10; // Wait for read
    if (data_out !== 16'd5) begin
      $display("Error: data_out mismatch on register 0 write/read.");
      err = 1;
    end

        // Test Case 2: Write and read from register 1
    data_in = 16'd6; // Test data
    writenum = 3'b001; // Select register 1
    write = 1'b1; // Enable write
    #20; // Wait for a clock edge
    write = 1'b0; // Disable write
    readnum = 3'b001; // Select register 1 to read
    #10; // Wait for read
    if (data_out !== 16'd6) begin
      $display("Error: data_out mismatch on register 1 write/read.");
      err = 1;
    end

    // Test Case 3: Check that register 0 still holds previous value
    readnum = 3'b000; // Select register 0 to read
    #10; // Wait for read
    if (data_out !== 16'd5) begin
      $display("Error: data_out mismatch on register 0, expected previous value.");
      err = 1;
    end

    // Test Case 4: Write to register 2 and read back
    data_in = 16'd7;
    writenum = 3'b010; // Select register 2
    write = 1'b1; // Enable write
    #20; // Wait for a clock edge
    write = 1'b0; // Disable write
    readnum = 3'b010; // Select register 2 to read
    #10; // Wait for read
    if (data_out !== 16'd7) begin
      $display("Error: data_out mismatch on register 2 write/read.");
      err = 1;
    end

    // Test Case 5: Ensure no write occurs when write signal is deasserted
    data_in = 16'd15; // Test data that should not be written
    writenum = 3'b011; // Select register 3
    write = 1'b0; // Write is deasserted
    #20; // Wait for a clock edge
    readnum = 3'b011; // Select register 3 to read
    #10; // Wait for read
    if (data_out === 16'd15) begin
      $display("Error: data_out should not be updated when write is deasserted.");
      err = 1;
    end


    // Finish testbench
    
    if (err === 0) begin
      $display("All tests passed. - regfile");
    end else begin
      $display("There were errors during testing.");
    end
     // End simulation
  end
endmodule
