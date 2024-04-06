//DEFINING SWTITCH
`define S0  4'b0000
`define S1  4'b0001
`define S2  4'b0010
`define S3  4'b0011
`define S4  4'b0100
`define S5  4'b0101
`define S6  4'b0110
`define S7  4'b0111
`define S8  4'b1000
`define S9  4'b1001
`define S10 4'b1010
`define S11 4'b1011
`define S12 4'b1100
`define S13 4'b1101
`define S14 4'b1110
`define S15 4'b1111
`define Sx 4'bxxxx

//DEFINING STATE
`define Oa 4'b0000 //0
`define Ob 4'b0001 //1
`define Oc 4'b0010 //2
`define Od 4'b0011 //3
`define Oe 4'b0100 //4
`define Of 4'b0101 //5
`define Og 4'b0110 //6
//--------------OPENING PATH
`define Ca 4'b0111  // 7
`define Cb 4'b1000  // 8
`define Cc 4'b1001  // 9
`define Cd 4'b1010  // 10 
`define Ce 4'b1011  // 11 
`define Cf 4'b1100  // 12
//----------------CLOSING PATH
`define H0 7'b1000000
`define H1 7'b1111001
`define H2 7'b0100100
`define H3 7'b0110000
`define H4 7'b0011001
`define H5 7'b0010010
`define H6 7'b0000010
`define H7 7'b1111000
`define H8 7'b0000000
`define H9 7'b0010000
//-----------------HEX 7segments display




module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low


  //FSM - next state logic
  reg[3:0] current_state, next_state;

  always @(current_state, SW) begin
        case(current_state) 
        // Opening Path
        `Oa: if (SW[3:0] == `S6) next_state = `Ob; else next_state = `Ca; //Oa~Og: Opening path, Ca~Cf: closing path
        `Ob: if (SW[3:0] == `S6) next_state = `Oc; else next_state = `Cb;
        `Oc: if (SW[3:0] == `S5) next_state = `Od; else next_state = `Cc;
        `Od: if (SW[3:0] == `S2) next_state = `Oe; else next_state = `Cd;
        `Oe: if (SW[3:0] == `S3) next_state = `Of; else next_state = `Ce;
        `Of: if (SW[3:0] == `S9) next_state = `Og; else next_state = `Cf;
        // Closing path
        `Ca: next_state = `Cb; //once in closing path it remains in closing path
        `Cb: next_state = `Cc;
        `Cc: next_state = `Cd;
        `Cd: next_state = `Ce;
        `Ce: next_state = `Cf;

        `Og: next_state = `Og; // Stays in OPEN state unless reset.
        `Cf: next_state = `Cf; // Stays in CLOSED state unless reset.
        default: next_state = `Oa;
        endcase
end

always @(posedge clk) begin //Reset Clock logic
        if (~rst_n) current_state = `Oa; //If reset pressed, initialize to 0
        else current_state <= next_state; //If reset not pressed, move to next state
end
        
        
//Output logic
always @(*) begin 
    
    //Clear HEX displays
    HEX0 = 7'b1111111;
    HEX1 = 7'b1111111;
    HEX2 = 7'b1111111;
    HEX3 = 7'b1111111;
    HEX4 = 7'b1111111;
    HEX5 = 7'b1111111;
    
    case(SW[3:0]) //for displaying numbers
    
        `S0 : HEX0 = `H0; //0 on HEX
        `S1 : HEX0 = `H1; //1 on HEX
        `S2 : HEX0 = `H2; //2 on HEX
        `S3 : HEX0 = `H3; //3 on HEX
        `S4 : HEX0 = `H4; //and so on
        `S5 : HEX0 = `H5;
        `S6 : HEX0 = `H6;
        `S7:  HEX0 = `H7;
        `S8 : HEX0 = `H8;
        `S9 : HEX0 = `H9;
        `S10: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        `S11: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        `S12: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        `S13: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        `S14: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        `S15: {HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b0000110, 7'b0101111,7'b0101111, `H0, 7'b0101111};//ErrOr
        default: HEX1 = 7'b1111111;

    endcase
  
    case(current_state) //Displays for the final open path and closed path states
        `Og : {HEX3, HEX2, HEX1, HEX0} = {7'b1000000, 7'b0001100, 7'b0000110, 7'b0101011}; //OPEn
        `Cf : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b1000110, 7'b1000111, 7'b1000000,
         7'b0010010, 7'b0000110, 7'b0100001}; //CLOSEd
        default: ;  //default does nothing
    endcase

end
        
        
  
        
endmodule
    



