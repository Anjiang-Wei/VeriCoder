module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion
);
    // Internal signals and registers
    reg [4:0] i;        // Shift count register
    reg [15:0] areg;    // Register to hold multiplicand
    reg [15:0] breg;    // Register to hold multiplier
    reg [31:0] yout_r;  // Register to hold product
    reg done_r;         // Register to hold done signal

    // Assign output signals
    assign yout = yout_r;
    assign done = done_r;

    // Clock and reset process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
        end else if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (i < 17) begin
                if (i == 16) begin
                    done_r <= 1;
                end else if (i == 17) begin
                    done_r <= 0;
                end
                if (areg[i-1] == 1) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
            end else begin
                i <= 0;
            end
        end else begin
            i <= 0;
            done_r <= 0;
        end
    end
endmodule