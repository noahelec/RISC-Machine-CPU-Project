module datapath(
    input clk,
    input loada,
    input loadb,
    input loadc,
    input loads,
    input write,
    input asel,
    input bsel,
    input [1:0] shift,
    input [1:0] ALUop,
    input vsel,
    input [15:0] datapath_in,
    input [2:0] writenum,
    input [2:0] readnum,
    output [15:0] datapath_out,
    output Z_out
);


  //Shifter
  reg [15:0] in;
  wire [15:0] sout;
  //Regfile
  reg [15:0] data_in;
  reg [15:0] data_out;
  //ALU
  reg [15:0] Ain, Bin, out;
  wire Z;

  //other connections
  reg [15:0] A, C;
  assign datapath_out = C;
  reg tempZ_out;
  assign Z_out = tempZ_out;

  //instaniation
  ALU alu(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z));
  shifter shifter(.in(in), .shift(shift), .sout(sout));
  regfile REGFILE(.data_in(data_in), .writenum(writenum), .write(write), .readnum(readnum), .clk(clk), .data_out(data_out));

  // Multiplexers
   
   assign  Ain = asel ? 16'b0 : A; // Select input for ALU A
   assign Bin = bsel ? {11'b0, datapath_in[4:0]} : sout; // Select input for ALU B
   assign  data_in = vsel ? datapath_in : C; // Select input for register file
  

  always @(posedge clk) begin
    if (loada)
        A <= data_out;  // Load 'A' with 'data_out' when 'loada' signal is asserted
    if (loadb)
        in <= data_out;  // Load 'in' with 'data_out' when 'loadb' signal is asserted
    if (loadc)
        C <= out;  // Load 'C' with 'out' when 'loadc' signal is asserted
    if (loads)
        tempZ_out <= Z;  // Invert 'Z' and load into 'tempZ_out' when 'loads' signal is asserted
end

endmodule: datapath