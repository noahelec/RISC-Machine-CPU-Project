`timescale 1ps / 1ps

module instdec_tb();

    // Inputs
    reg [15:0] instreg;
    reg [2:0] nsel;

    // Outputs
    wire [2:0] opcode, writenum, readnum;
    wire [1:0] ALUop, op, shift;
    wire [15:0] sximm8, sximm5;

    // Instantiate the Unit Under Test (UUT)
    instdec DUT (
        .instreg(instreg), 
        .nsel(nsel), 
        .op(op), 
        .opcode(opcode), 
        .ALUop(ALUop), 
        .sximm8(sximm8), 
        .sximm5(sximm5), 
        .shift(shift), 
        .writenum(writenum), 
        .readnum(readnum)
    );

    initial begin
        // Initialize Inputs
        instreg = 0;
        nsel = 0;

        // Add stimulus here
        // Test MOV Rn, #<im8>
        testInstruction(16'b1101000001010101, 3'b001); // MOV R5, #85

        // Test MOV Rd, Rm, {<sh_op>}
        testInstruction(16'b1100000100100011, 3'b010); // MOV R1, R3, LSL #2

        // Test ADD Rd, Rn, Rm, {<sh_op>}
        testInstruction(16'b1101000001000101, 3'b001); // ADD R0, R4, R5

        // Test CMP Rn, Rm, {<sh_op>}
        testInstruction(16'b1101001000110010, 3'b001); // CMP R3, R2, LSR #1
//hello noah
        // Test AND Rd, Rn, Rm, {<sh_op>}
        testInstruction(16'b1010000101001000, 3'b001); // AND R2, R0, R3, LSL #2

        // Test MVN Rd, Rm, {<sh_op>}
        testInstruction(16'b1101100001000110, 3'b010); // MVN R4, R6, LSR #1

        // Check invalid nsel
        testInstruction(16'b1101000001010101, 3'b111); // Undefined nsel

        $stop;
    end

    // Task to check outputs and display results
    task checkOutputs;
        begin
            $display("Time = %d, instreg = %b, nsel = %b", $time, instreg, nsel);
            $display("Outputs: op = %b, opcode = %b, ALUop = %b, shift = %b, sximm8 = %b, sximm5 = %b, readnum = %b, writenum = %b\n", op, opcode, ALUop, shift, sximm8, sximm5, readnum, writenum);
        end
    endtask

    // Task to test instructions
    task testInstruction;
        input [15:0] instruction;
        input [2:0] select;
        begin
            instreg = instruction;
            nsel = select;
            #10; // Wait for the outputs to settle
            checkOutputs();
            // Add assertions if necessary to validate the output automatically
        end
    endtask

endmodule
