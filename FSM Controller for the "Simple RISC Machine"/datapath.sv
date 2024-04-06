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
    input [1:0] vsel,
    input [2:0] writenum,
    input [2:0] readnum,
    input [7:0] pc,
    input [15:0] sximm8,
    input [15:0] sximm5,
    input [15:0] mdata,
    output [15:0] datapath_out,
    output Z_out,
    output N_out,
    output V_out
);


  //Shifter
  reg [15:0] in;
  wire [15:0] sout;
  //Regfile
  reg [15:0] data_in;
  reg [15:0] data_out;
  //ALU
  reg [15:0] Ain, Bin, out;
  wire Z,N,V;
  

  //other connections
  reg [15:0] A, C;
  assign datapath_out = C;
  reg [2:0] tempZ_out;
  assign Z_out = tempZ_out[2];
  assign V_out = tempZ_out[0];
  assign N_out = tempZ_out[1];

  

  //instaniation
  ALU alu(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z), .N(N), .V(V));
  shifter shifter(.in(in), .shift(shift), .sout(sout));
  regfile REGFILE(.data_in(data_in), .writenum(writenum), .write(write), .readnum(readnum), .clk(clk), .data_out(data_out));

  // Multiplexers - make 4 to 1
   
   assign Ain = asel ? 16'b0 : A; // Select input for ALU A
   assign Bin = bsel ? sximm5 : sout; // Select input for ALU B

//assign  data_in = vsel ? datapath_in : C; // Select input for register file

always_comb begin
    case(vsel)
        2'b11: data_in = 16'b0; //mdata assign to 0 - fix, should be 16 bits
        2'b10: data_in = sximm8; // sximm8
        2'b01: data_in = 8'd0; //PC - program counter assign to 0 - poss fix
        2'b00: data_in = C;
        default: data_in <= 1'b0; // Default case can be set as per design requirement
    endcase
end

  always @(posedge clk) begin
    if (loada)
        A <= data_out;  // Load 'A' with 'data_out' when 'loada' signal is asserted
    if (loadb)
        in <= data_out;  // Load 'in' with 'data_out' when 'loadb' signal is asserted
    if (loadc)
        C <= out;  // Load 'C' with 'out' when 'loadc' signal is asserted
    if (loads)
        tempZ_out <= {Z,V,N};  // Invert 'Z' and load into 'tempZ_out' when 'loads' signal is asserted
end

endmodule: datapath