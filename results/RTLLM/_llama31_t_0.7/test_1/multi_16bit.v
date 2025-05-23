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
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [3:0] i; // Shift count register

reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        i <= 4'd0;
    else if (start && i < 16'd17)
        i <= i + 1;
    else if (!start)
        i <= 4'd0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done_r <= 1'b0;
    else if (i == 16'd16)
        done_r <= 1'b1;
    else if (i == 16'd17)
        done_r <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end
    else begin
        if (i == 4'd0) begin
            areg <= ain;
            breg <= bin;
        end
        else if (i > 4'd0 && i < 17) begin
            if (areg[i-1] != 0)
                yout_r <= {yout_r, {16{breg[15]}}, breg << (i - 1)};
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 1'b0;
    else
        done <= done_r;
end

assign yout = yout_r;

endmodule