module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output [31:0] yout, // Product output with a data width of 32 bits.
    output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);
    reg [4:0] i;        // Shift count register
    reg [15:0] areg;    // Register to store the multiplicand
    reg [15:0] breg;    // Register to store the multiplier
    reg [31:0] yout_r;  // Register to store the product
    reg done_r;         // Register to store the multiplication completion flag

    // Data bit control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 0;
        end else if (start && i < 17) begin
            i <= i + 1;
        end else if (!start) begin
            i <= 0;
        end
    end

    // Multiplication completion flag generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 0;
        end else if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
        end else if (start) begin
            case (i)
                0: begin
                    areg <= ain;
                    breg <= bin;
                end
                1: begin
                    if (areg[0] == 1)
                        yout_r <= breg;
                end
                default: begin
                    if (i > 0 && i < 17 && areg[i-1] == 1)
                        yout_r <= yout_r + (breg << (i-1));
                end
            endcase
        end
    end

    // Output assignment
    assign done = done_r;
    assign yout = yout_r;

endmodule