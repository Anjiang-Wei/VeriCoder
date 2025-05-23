module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

    // Internal registers
    reg [15:0] areg; // Multiplicand register
    reg [15:0] breg; // Multiplier register
    reg [31:0] yout_r; // Product register
    reg [3:0] i; // Shift count register
    reg done_r; // Multiplication completion flag

    // Assign output signals
    assign yout = yout_r;
    assign done = done_r;

    // State machine logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
            done_r <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
        end else begin
            if (start && i < 17) begin
                i <= i + 1;
            end else if (!start) begin
                i <= 0;
            end

            if (i == 16) begin
                done_r <= 1;
            end else if (i == 17) begin
                done_r <= 0;
            end

            // Shift and accumulate operation
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (i > 0 && i < 17) begin
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
        end
    end

endmodule