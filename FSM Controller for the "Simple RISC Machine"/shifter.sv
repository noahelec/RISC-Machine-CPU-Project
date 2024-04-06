module shifter(in, shift, sout);
    input [15:0] in; // 16-bit input from register B
    input [1:0] shift; // 2-bit shift control signal
    output reg [15:0] sout;

    always @* begin // Sensitivity list removed, implies sensitivity to all inputs
        case (shift)
            2'b00: sout = in; // No shift
            2'b01: sout = in << 1; // Shift left by 1, LSB is 0
            2'b10: sout = {1'b0, in[15:1]}; // Shift right by 1, MSB is 0
            2'b11: sout = {in[15], in[15:1]}; // Shift right by 1, MSB is copy of B[15]
            default: sout = in; // Default case (should not occur)
        endcase
    end
endmodule
