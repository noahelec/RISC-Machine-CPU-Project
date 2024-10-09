module regfile_lowpower (
    input  wire [15:0] data_in,   // Data to be written
    input  wire [2:0]  writenum,  // Write address
    input  wire        write,     // Write enable
    input  wire [2:0]  readnum,   // Read address
    input  wire        clk,       // Clock signal
    output wire [15:0] data_out   // Data output
);
    // Define a single register array with 8 registers of 16 bits each
    reg [15:0] R[7:0];

    assign data_out = R[readnum];   // Combinational read logic

    always @(posedge clk) begin    // Sequential write logic with synchronous write
        if (write) begin
            R[writenum] <= data_in;
        end
    end

endmodule
