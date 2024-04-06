`timescale 1ps/ 1ps

module tb_lab3();

  reg [3:0] SW;
  reg [3:0] KEY;
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  

  // Instantiate the lab3_top module
  lab3_top DUT (
    .SW(SW),
    .KEY (KEY),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5)
   
  );



  // Clock generation
  always begin
    KEY[0] = 0; // inverse of the clock
    #5;
    KEY[0] = 1;
    #5;
  end

  // Test procedure
  initial begin

    //Initial Conditions
    SW = 4'b0000;
    KEY = 4'b1111;

    //TEST OPEn
    SW = 4'b0110; //6
    #10;
    SW = 4'b0110; //6
    #20;
    SW = 4'b0101; //5
    #20;
    SW = 4'b0010; //2
    #20
    SW = 4'b0011; //3
    #20;
    SW = 4'b1001; //9
    #20;

    // give time to modelsim to change to open state
    #10;
    // Reset #1
    KEY[3] = 0;
    #10;
    KEY[3] = 1;
    #10;

    //TEST CLOSEd
    SW = 4'b0000; //0
    #10;
    SW = 4'b0001; //1
    #10;
    SW = 4'b0010; //2
    #10;
    SW = 4'b0011; //3
    #10
    SW = 4'b0100; //4
    #10;
    SW = 4'b0101; //5
    #10;
    
    // Buffer time
    #10;

    // Reset #2
    KEY[3] = 0;
    #5;
    KEY[3] = 1;
    #5;

    //TEST ErrOr 1
    SW = 4'b1010; //10
    #10;

    //Test Error 2
    SW = 4'b1101; //13
    #10;

    $stop;
  end

  initial begin 

     $monitor("At time %0d, SW=%b, HEX0=%b, HEX1=%b, HEX2=%b, HEX3=%b, HEX4=%b, HEX5=%b",
      $time, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
  
  end

endmodule: tb_lab3
