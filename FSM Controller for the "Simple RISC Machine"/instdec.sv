module instdec (instreg, nsel, op, opcode, ALUop, sximm8, sximm5, shift, writenum, readnum);
  input [15:0] instreg;
  input [2:0] nsel;
  output [2:0] opcode, writenum, readnum;
  output [1:0] ALUop, op, shift;
  output [15:0] sximm8, sximm5;

  assign op = instreg[12:11];
  assign opcode = instreg[15:13];
  assign ALUop = instreg [12:11];
  assign shift = instreg [4:3]; //sh in table 1
  assign sximm5 = { {11{instreg[4]}}, instreg[4:0] };  //5bits changed to 16-bits 
  assign sximm8 = { {8{instreg[7]}}, instreg[7:0] };   //8bits changed to 16-bits 
reg [2:0] readnum;
reg [2:0] writenum;

    wire [2:0] Rn, Rm, Rd;
    assign Rm = instreg[2:0];
    assign Rd = instreg[7:5];
    assign Rn = instreg[10:8]; 
always_comb begin  // Sensitivity list for combinational logic
    case (nsel)
        3'b001: readnum = instreg[10:8]; // Rn
        3'b010: readnum = instreg[7:5];  // Rd
        3'b100: readnum = instreg[2:0];  // Rm
        default:;         // Undefined state
    endcase
    writenum = readnum; // Assign readnum to writenum
end
endmodule