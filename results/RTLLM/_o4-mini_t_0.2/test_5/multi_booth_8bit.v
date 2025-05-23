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
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg  [4:0] ctr;        // 0..16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize on reset
            // sign‑extend the inputs to 16 bits
            multiplier    <= {{8{a[7]}}, a};
            multiplicand  <= {{8{b[7]}}, b};
            p             <= 16'd0;
            ctr           <= 5'd0;
            rdy           <= 1'b0;
        end
        else begin
            if (ctr < 5'd16) begin
                // Each cycle shift and add if needed
                if (multiplier[ctr])
                    p <= p + multiplicand;
                multiplicand <= multiplicand << 1;
                ctr          <= ctr + 5'd1;
            end
            else begin
                // Done
                rdy <= 1'b1;
            end
        end
    end

endmodule