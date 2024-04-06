`timescale 1ps / 1ps

module shifter_tb;
    // Inputs
    reg [15:0] in;
    reg [1:0] shift;

    // Outputs
    wire [15:0] sout;

    // Error flag
    reg err;

    // Instantiate the Unit Under Test (DUT)
    shifter DUT (
        .in(in), 
        .shift(shift), 
        .sout(sout)
    );

    // Test stimulus
    initial begin
        // Initialize Inputs
        in = 0;
        shift = 0;
        err = 0;

        // Apply test cases
        #10 in = 16'b1111000011001111; shift = 2'b00; // No shift
        #10 if (sout !== in) err = 1;

        #10 in = 16'b1111000011001111; shift = 2'b01; // Shift left by 1
        #10 if (sout !== (in << 1)) err = 1;

        #10 in = 16'b1111000011001111; shift = 2'b10; // Shift right by 1, MSB is 0
        #10 if (sout !== {1'b0, in[15:1]}) err = 1;

        #10 in = 16'b1111000011001111; shift = 2'b11; // Shift right by 1, MSB is copy of in[15]
        #10 if (sout !== {in[15], in[15:1]}) err = 1;

        // Check default case (should not occur)
        #10 shift = 2'bxx; // Invalid shift value
        #10 if (sout !== in) err = 1;

        // Finish test, check for errors
        #10 if (err === 0) begin
            $display("TEST PASSED - SHIFTER");
        end else begin
            $display("TEST FAILED - SHIFTER");
        end

        // End simulation
        
    end
      
endmodule
