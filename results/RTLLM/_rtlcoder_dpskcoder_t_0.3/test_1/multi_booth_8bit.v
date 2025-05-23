module top_module(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output rdy
);

    reg [4:0] ctr;
    reg [15:0] multiplicand, multiplier;
    reg [15:0] p;
    reg rdy;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ctr <= 5'b00000;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0000000000000000;
            rdy <= 1'b0;
        end else begin
            if (ctr < 5'b10000) begin
                multiplicand <= {multiplicand[14:0], 1'b0};
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                ctr <= ctr + 1;
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule