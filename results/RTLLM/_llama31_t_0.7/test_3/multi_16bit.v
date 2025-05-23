module multi_16bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input start,        // Chip enable signal. 
    input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
    input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.

    output reg [31:0] yout, // Product output with a data width of 32 bits.
    output reg done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [16:0] i;    // Shift count register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 0;
    else if (start && i < 17)
        i <= i + 1;
    else if (!start)
        i <= 0;
end

reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 0;
    else if (i == 16)
        done_r <= 1;
    else if (i == 17)
        done_r <= 0;
end

reg [15:0] yout_r; // Product register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
        end else if (areg[i-1]) begin
            yout_r <= {yout_r << i, 16'h0};
            yout_r <= yout_r + breg;
        end
    end
end

assign yout = yout_r;

always @(posedge clk or negedge rst_n) begin
    done <= done_r;
end

endmodule // multi_16bit