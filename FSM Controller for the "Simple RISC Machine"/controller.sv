`define WAIT 3'b000
`define DECODE 3'b001
`define LOADA 3'b010
`define LOADB 3'b011
`define ALU_STATE 3'b100
`define WRITEIMM_STATE 3'b101
`define WRITEIMM2_STATE 3'b110
`define RD_STATE 3'b111

module controller (clk, s, reset, write, op, opcode, w, loada, loadb, loadc, loads, vsel, nsel, asel, bsel);
  input clk;
  input s;
  input reset;
  input [2:0] opcode;
  input [1:0] op;
  output reg w, loada, loadb, loadc, loads, asel, bsel, write;
  output reg [2:0] nsel;
  output reg [1:0] vsel;

    // define state register
    reg [2:0] state;
    
    // Initialize FSM state 
    initial begin
        state = `WAIT;
    end

    // FSM state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= `WAIT; end
        else begin
    {w, loada, loadb, loadc, loads, asel, bsel, write, nsel} = 0;
    vsel = 2'b10;
    nsel = 3'b000; // No register selected by default
      // Default select signals for the register file
    case (state)
        `WAIT: begin
            w = 1;
            // Define control signals for WAIT state
            if (s) begin
                state <= `DECODE; // Transition to DECODE when start signal is deasserted
            end else begin
                state <= `WAIT;
            end
        end

        `DECODE: begin
                // Set control signals for the decode stage if needed
                // Determine the next state based on opcode and op
                if (opcode == 3'b110) begin // Move Instructions
                    if (op == 2'b10) begin // MOV Rn, #<im8>
                        state <= `WRITEIMM_STATE; //
                    end 
                    else 
                    if (op == 2'b00) begin // MOV Rd, Rm{, <sh_op>}
                        state <= `WRITEIMM2_STATE;
                    end else state <= `WAIT;
                end 
                else
                if (opcode == 3'b101) begin // ALU Instructions
                    if (op == 2'b00) begin
                        state <= `LOADA;
                    end
                    else
                    if (op == 2'b01)begin
                        state <= `LOADA;
                    end
                    else
                    if (op == 2'b10)begin
                        state <= `LOADA;
                    end
                    else
                    if (op == 2'b11)begin
                        state <= `LOADB;
                    end
                end
                else state <= `WAIT;
                // ... Add cases for other opcodes as needed
            end
        `LOADA: begin
                //load a register with Rn
                nsel = 3'b001;
                write = 1;
                loada = 1;
                asel = 0;
                state = `LOADB;
            end
        `LOADB: begin
                // Load B register with Rm
                nsel = 3'b100; //hello?
                write = 1;
                loadb = 1;
                bsel = 0;
                state = `ALU_STATE;
            end
        `ALU_STATE: begin
                // Perform the ALU operation
                //asel = 0; bsel = 0; 
                
                if (op == 2'b00) begin
                    loadc = 1;
                    loads = 1;
                    state = `RD_STATE;
                end else
                if (op == 2'b01) begin// CMP instruction
                    loadc = 1; 
                    loads = 1; // Update status flags
                    state = `WAIT;
                end else 
                if (op == 2'b10) begin
                    loadc = 1;
                    loads = 1;
                    state = `RD_STATE;
                end else
                if (op == 2'b11) begin
                    loadc = 1;
                    loads = 1;
                    state = `RD_STATE;
                end
            end
        `RD_STATE: begin 
                vsel = 2'b00;
                nsel = 3'b010;
                write = 1;
                state <= `WAIT;
             

        end
        `WRITEIMM_STATE: begin //writeimm state to Rn
                // Write the result or immediate value to the destination register
                vsel = 2'b00;
                nsel = 3'b001; 
                write = 1;
                loada = 1;
                asel = 0;
                loadc = 1;
                loads = 1;
                state = `WAIT; // Go back to WAIT state
            end
        `WRITEIMM2_STATE: begin
            nsel = 3'b010;
            write = 1;
            loadb = 1;
            //shifter happens
            bsel = 0;
            loads = 1;
            loadc = 1;
            state = `WAIT;
        end

            default: begin
                // Handle unexpected state
                state = `WAIT;
            end
        endcase
    end
    end


endmodule