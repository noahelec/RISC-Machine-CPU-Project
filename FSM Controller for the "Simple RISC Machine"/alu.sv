module ALU(Ain,Bin,ALUop,out,Z,N,V);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg Z; 
    output reg N;
    output reg V;

    always @(Ain, Bin, ALUop) begin //operation logic
        case (ALUop) 
            2'b00: begin out <= Ain + Bin; 
                V = ((Ain[15] & Bin[15] & ~out[15]) | (~Ain[15] & ~Bin[15] & out[15])) ? 1'b1 : 1'b0; end //check msb of Ain and Bin, if both positive, out should be positive, if neg, assign v= 1. and vice versa
            2'b01: begin out <= Ain - Bin;
                V = ((~Ain[15] & Bin[15] & out[15]) | (Ain[15] & ~Bin[15] & out[15])) ? 1'b1 : 1'b0; end //check msb of Ain and Bin, if neg - pos, out should be positive, if neg, assign v= 1. and vice versa
            2'b10: begin out <= Ain & Bin;
                V = 1'b0; end //overflow cannot occur with and function
            2'b11: begin out <= ~Bin;
                V = 1'b0; end //overflow cannot occur with not function
        endcase 
    end
    
    always @(out) begin
        Z = (out == 16'b0) ? 1'b1 : 1'b0; //z_flag operational logic
        N = (out[15] == 1'b1) ? 1'b0 : 1'b1; //negative flag operational logic
    end
endmodule