`timescale 1ns / 1ps
module multi_booth_8bit (
    output reg [15:0] p,
    output reg        rdy,
    input             clk,
    input             reset,
    input      [7:0]  a,
    input      [7:0]  b
);

    // Internal registers
    reg [15:0] multiplier;    // sign‐extended copy of a
    reg [15:0] multiplicand;  // sign‐extended copy of b
    reg [4:0]  ctr;           // up to 16 steps

    // Sequential Booth‐style shift‐add multiplier
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // on reset, load operands (sign‐extended), clear product/counter/ready
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p            <= 16'b0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end
        else begin
            if (ctr < 5'd16) begin
                // if the current bit of the multiplier is 1, add the aligned multiplicand
                if (multiplier[ctr])
                    p <= p + multiplicand;
                // shift multiplicand left for next bit
                multiplicand <= multiplicand << 1;
                // next bit
                ctr <= ctr + 1'b1;
            end
            else begin
                // finished 16 cycles → product is ready
                rdy <= 1'b1;
            end
        end
    end

endmodule