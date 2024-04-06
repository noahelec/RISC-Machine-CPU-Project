`timescale 1ps / 1ps



module controller_tb;

    reg clk, s, reset;
    reg [2:0] opcode;
    reg [1:0] op;
    wire w, loada, loadb, loadc, loads, asel, bsel, write;
    wire [2:0] nsel;
    wire [1:0] vsel;

    // Instantiate the Unit Under Test (UUT)
    controller DUT (
        .clk(clk), 
        .s(s), 
        .reset(reset), 
        .op(op), 
        .opcode(opcode),
        .w(w), 
        .loada(loada), 
        .loadb(loadb), 
        .loadc(loadc), 
        .loads(loads), 
        .asel(asel), 
        .bsel(bsel), 
        .write(write), 
        .nsel(nsel), 
        .vsel(vsel)
    );

    // Clock generation
    always #10 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize Inputs
        clk = 0;
        s = 0;
        reset = 0;
        opcode = 0;
        op = 0;
        op = 0;

        // Reset the system
        #20;
        reset = 1; #20;
        reset = 0; #20;

        // Test various scenarios

        // Scenario 1: Basic WAIT to DECODE transition
        s = 1; #20;
        s = 0; #40; // Should transition to DECODE and then WAIT

        // Scenario 2: Test MOV Rn, #<im8>
        s = 1; #20;
        s = 0; opcode = 3'b110; op = 2'b10; #40; // Should go to WRITEIMM_STATE

        // Scenario 3: Test MOV Rd, Rm{, <sh_op>}
        s = 1; #20;
        s = 0; opcode = 3'b110; op = 2'b00; #40; // Should go to WRITEIMM2_STATE

        // Scenario 1: ALU Instruction - Add
s = 1; #20;
s = 0; opcode = 3'b101; op = 2'b00; #60; // Check the sequence of states and outputs

// Scenario 2: Load Instruction
s = 1; #20;
s = 0; opcode = 3'bXXX; op = 2'bXX; #40; // Replace XXX and XX with appropriate values

// Scenario 3: Write Immediate Instruction
s = 1; #20;
s = 0; opcode = 3'b110; op = 2'b01; #40; // Test for different op values

// Scenario 4: Edge Case: Unrecognized Opcode
s = 1; #20;
s = 0; opcode = 3'bXXX; #40; // Use an opcode not handled in your FSM

// Scenario 5: Test Reset While Operating
s = 1; #20;
reset = 1; #20;
reset = 0; #20; // Verify that the FSM returns to WAIT state

// Scenario 6: Continuous Operations
s = 1; #20;
s = 0; opcode = 3'b101; op = 2'b00; #40;
s = 1; #20;
s = 0; opcode = 3'b110; op = 2'b10; #40; // and so on


        // Finish the simulation
        #100;
        $finish;
    end

    // Optional: Display changes in state and signals for debugging
    initial begin
        $monitor("Time=%g, State=%b, Opcode=%b, Op=%b, op=%b, Outputs={w=%b, loada=%b, loadb=%b, loadc=%b, loads=%b, asel=%b, bsel=%b, write=%b, nsel=%b, vsel=%b}",
                 $time, DUT.state, opcode, op, op, w, loada, loadb, loadc, loads, asel, bsel, write, nsel, vsel);
    end

endmodule
