`timescale 1ps / 1ps

module ALU_tb;

    // Inputs
    reg [15:0] Ain;
    reg [15:0] Bin;
    reg [1:0] ALUop;

    // Outputs
    wire [15:0] out;
    wire Z;

    // Error signal
    reg err;

    // Instantiate the ALU module
    ALU DUT (
        .Ain(Ain), 
        .Bin(Bin), 
        .ALUop(ALUop), 
        .out(out), 
        .Z(Z)
    );

    // Testbench logic
    initial begin
        // Initialize Inputs and error
        Ain = 0;
        Bin = 0;
        ALUop = 0;
        err = 0;

        // Wait for the global reset
        #10;

        // Test addition
        Ain = 16'd10;
        Bin = 16'd15;
        ALUop = 2'b00; // Add operation - expecting 15
        #10;
        if (out !== Ain + Bin) begin
            $display("Addition Test Failed!");
            err = 1;
        end
        if (Z !== (out == 0)) begin
            $display("Zero Flag Failed for Addition!");
            err = 1;
        end

        // Test subtraction
        Ain = 16'd20;
        Bin = 16'd15;
        ALUop = 2'b01; // Subtract operation - expecting 5
        #10;
        if (out !== Ain - Bin) begin
            $display("Subtraction Test Failed!");
            err = 1;
        end
        if (Z !== (out == 0)) begin
            $display("Zero Flag Failed for Subtraction!");
            err = 1;
        end

        // Test AND
        Ain = 16'd5;
        Bin = 16'd3;
        ALUop = 2'b10; // AND operation - expecting 1
        #10;
        if (out !== (Ain & Bin)) begin
            $display("AND Test Failed!");
            err = 1;
        end
        if (Z !== (out == 0)) begin
            $display("Zero Flag Failed for AND!");
            err = 1;
        end

        // Test NOT
        Bin = 16'd10;
        ALUop = 2'b11; // NOT operation - expecting 1
        #10;
        if (out !== ~Bin) begin
            $display("NOT Test Failed!");
            err = 1;
        end
        if (Z !== (out == 0)) begin
            $display("Zero Flag Failed for NOT!");
            err = 1;
        end

        // Test zero flag specifically
        Ain = 16'd0;
        Bin = 16'd0;
        // Test with addition which should result in zero
        ALUop = 2'b00; // Add operation with zero result
        #10;
        if (out !== 0) begin
            $display("Zero Test Failed with addition!");
            err = 1;
        end
        if (Z !== 1) begin
            $display("Zero Flag should be set for zero output with addition!");
            err = 1;
        end

        // Test with subtraction which should result in zero
        ALUop = 2'b01; // Subtract operation with zero result
        #10;
        if (out !== 0) begin
            $display("Zero Test Failed with subtraction!");
            err = 1;
        end
        if (Z !== 1) begin
            $display("Zero Flag should be set for zero output with subtraction!");
            err = 1;
        end

        // Test with AND which should result in zero
        ALUop = 2'b10; // AND operation with zero result
        #10;
        if (out !== 0) begin
            $display("Zero Test Failed with AND!");
            err = 1;
        end
        if (Z !== 1) begin
            $display("Zero Flag should be set for zero output with AND!");
            err = 1;
        end

        // Check if there were any errors
        if (err) begin
            $display("Some tests failed. Please check the error messages above.");
        end else begin
            $display("All tests passed successfully.");
        end
        
        
    end
      
endmodule
