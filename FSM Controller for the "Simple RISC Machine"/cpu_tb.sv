module cpu_tb();
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N,V,Z,w;

  reg err; //register to track errors during testing

  cpu DUT(clk,reset,s,load,in,out,N,V,Z,w); //instantiate module for testing

  initial begin
    clk = 0; #5;
    forever begin //clock forever loop
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  initial begin //initialize
    err = 1'b0;
    reset = 1'b1; s = 1'b0; load = 1'b0; in = 16'b0; #10;
    reset = 1'b0; #10;

   // Test cases for CPU operations

    // MOV R0, #7 Test Case
    load = 1'b1; in = 16'b1101000000000111; 
    #10;
    load = 1'b0; s = 1'b1; 
    #10; 
    s = 1'b0; @(posedge w); // wait for w high 
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h7) begin
      err = 1; $display("Test Failed: MOV R0, #7"); $stop; //Check for test success and display outcome
    end

    // Testing MOV with different operands
    // MOV R1, #2
    in = 16'b1101000100000010; load = 1; 
    #10; 
    load = 0; s = 1; 
    #10; 
    s = 0; @(posedge w); // wait for w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
      err = 1; $display("Test Failed: MOV R1, #2"); $stop; //Check for test success and display outcome
    end

    //MOV R2, #5
    @(negedge clk);
    in = 16'b1101001000000101; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'h5) begin
      err = 1; $display("Test Failed: MOV R2, #5"); $stop;//Check for test success and display outcome
    end

    //Test MOV shifts
    
    //MOV R2, R0, LSL#1
    @(negedge clk); // wait for negedge
    in = 16'b1100000001001000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for w go high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd14) begin
      err = 1; $display("Test Failed: MOV R2, R0, LSL#1"); // Check for test success and display outcome
      $stop;
    end

    //MOV, R2, R1, LSR#1
    @(negedge clk); // wait for negedge
    in = 16'b1100000001010001; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for w go high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd1) begin
      err = 1; $display("Test Failed: MOV R2, R1, LSR#1"); //Check for test success and display outcome
      $stop;
    end

    //MOV R2, R1, LSL#0
    @(negedge clk); // wait for negedge
    in = 16'b1100000001000001; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for w go high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd2) begin
      err = 1; $display("Test Failed: MOV R2, R1, LSR#0"); //Check for test success and display outcome
      $stop;
    end

    //test ADD

    //ADD R2, R1, R0, LSL#1
    @(negedge clk); /// wait for negedge
    in = 16'b1010000101001000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for w go high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd16) begin
      err = 1; $display("Test Failed: ADD R2, R1, R0, LSL#1"); //Check for test success and display outcome
      $stop;
    end


    //ADD R2, R1, R0
    @(negedge clk); // wait for negedge
    in = 16'b1010000101000000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for w go high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R2 !== 16'd9) begin
      err = 1; $display("Test Failed: ADD R2, R1, R0"); //Check for test success and display outcome
      $stop;
    end


     //ADD R3, R2, R0
    @(negedge clk); // wait for negedge
    in = 16'b1010001001100000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'd16) begin
      err = 1; $display("Test Failed: ADD R3, R2, R0"); //Check for test success and display outcome
      $stop;
    end

    //test compare

    // CMP R1, R0 Test Case
    load = 1'b1; in = 16'b1010100100000000; 
    #10;
    load = 1'b0; s = 1'b1; 
    #10;
    s = 1'b0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.out !== -16'd5) begin
      err = 1; $display("Test Failed: CMP R1, R0"); $stop; //Check for test success and display outcome
    end
    
     //CMP R1, R2
    @(negedge clk); // wait for negedge
    in = 16'b1010100100000010; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.out !== -16'd7) begin
      err = 1; $display("Test Failed: CMP R1, R2"); //Check for test success and display outcome
      $stop;
    end

    //CMP R1, R3
    @(negedge clk); // wait for negedge
    in = 16'b1010100100000011; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.out !== -16'd14) begin
      err = 1; $display("Test Failed: CMP R1, R3"); //Check for test success and display outcome
      $stop;
    end

    //test AND

    //AND R4, R1, R0
    @(negedge clk); // wait for negedge
    in = 16'b1011000110000000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd2) begin
      err = 1; $display("Test Failed: AND R4, R1, R0"); //Check for test success and display outcome
      $stop;
    end

    //AND R4, R1, R2
    @(negedge clk); // wait for negedge
    in = 16'b1011000110000010; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd0) begin
      err = 1; $display("Test Failed: AND R4, R1, R2"); //Check for test success and display outcome
      $stop;
    end

    //AND R4, R3, R2
    @(negedge clk); // wait for negedge
    in = 16'b1011001110000010; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high again
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'd0) begin
      err = 1; $display("Test Failed: AND R4, R3, R2"); //Check for test success and display outcome
      $stop;
    end

    //test MVN

    //MVN R5, R0
    @(negedge clk); // wait for negedge
    in = 16'b1011100010100000; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== -16'd8) begin
      err = 1; $display("Test Failed: MNV R5, R0"); //Check for test success and display outcome
      $stop;
    end

    //MVN R5, R1
    @(negedge clk); // wait for negedge
    in = 16'b1011100010100001; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait w high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== -16'd3) begin 
      err = 1; $display("Test Failed: MNV R5, R1"); //Check for test success and display outcome
      $stop;
    end

    //MVN R5, R2
    @(negedge clk); // wait for negedge
    in = 16'b1011100010100010; load = 1;
    #10;
    load = 0; s = 1;
    #10
    s = 0; @(posedge w); // wait for high
    #10;
    if (cpu_tb.DUT.DP.REGFILE.R5 !== -16'd10) begin
      err = 1; $display("Test Failed: MVN R5, R2"); //Check for test success and display outcome
      $stop;
    end

    if (~err) $display("ALL TESTS PASSED SUCCESSFULLY");
    $stop;
  end
endmodule