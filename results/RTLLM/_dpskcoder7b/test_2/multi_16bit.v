module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [15:0] areg;    // Register for storing the multiplicand.
    reg [15:0] breg;    // Register for storing the multiplier.
    reg [31:0] yout_r;  // Register for storing the product output.
    reg [4:0] i;        // Register for storing the shift count.
    reg done_r;         // Register for storing the multiplication completion flag.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else if (start) begin
            if (i < 17) begin
                i <= i + 1'b1;
                if (i == 16) begin
                    areg <= ain;
                    breg <= bin;
                    done_r <= 1'b1;
                end else begin
                    if (breg[0]) begin
                        yout_r <= yout_r + (areg << (i - 1'b1));
                    end
                    breg <= breg >> 1'b1;
                end
            end else begin
                i <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

    assign yout = yout_r;
    assign done = done_r;
endmodule