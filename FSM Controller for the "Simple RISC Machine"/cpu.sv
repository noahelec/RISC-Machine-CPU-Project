module cpu(clk,reset,s,load,in,out,N,V,Z,w);
    input clk, reset, s, load;
    input [15:0] in;
    output reg [15:0] out;
    output reg N, V, Z, w;
    wire [2:0] readnum, writenum;
    wire loada, loadb, asel, bsel, loadc, loads, write;
    wire [1:0] shift, ALUop, vsel;
    reg[15:0] instreg;

    always_ff @(posedge clk) begin // instructiion register
        if (load)
            instreg <= in;  
    end
  
  wire [2:0] nsel, opcode;
  wire [1:0] op;
  wire [15:0] sximm5, sximm8;
  instdec instruction_decoder(.instreg(instreg), .nsel(nsel), .opcode(opcode), .op(op), 
                                .ALUop(ALUop), .sximm5(sximm5), .sximm8(sximm8), .shift(shift),
                                .readnum(readnum), .writenum(writenum));

  
 
  controller datapath_controller(.clk(clk), .reset(reset),.opcode(opcode),.op(op),.w(w),
                                    .loada(loada),.loadb(loadb),.loadc(loadc),.loads(loads),.asel(asel),
                                    .bsel(bsel),.vsel(vsel),.nsel(nsel),.write(write), .s(s));

  datapath DP(.clk(clk), //clock controlling datapath               
                .readnum(readnum), .vsel(vsel), .loada(loada), .loadb(loadb),  // register operand fetch stage               
                .shift(shift), .asel(asel), .bsel(bsel), .ALUop(ALUop), .loadc(loadc), .loads(loads), .sximm5(sximm5), // computation stage (sometimes called "execute")
                .writenum(writenum), .write(write), .sximm8(sximm8), .mdata(16'b0), .pc(8'b0), // set when "writing back" to register file               
                .datapath_out(datapath_out), .Z_out(Z), .N_out(N), .V_out(V));

endmodule



