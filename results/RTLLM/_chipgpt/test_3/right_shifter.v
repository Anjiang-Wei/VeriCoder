module register_m (
    input clk,
    input [15:0] in,
    output reg [15:0] out
);

reg [14:0] q;
initial q = 16'h0000; // zero to start with
always @(posedge clk)
    if (~in[15]) out <= out;
    else begin
        q <= {q[13:0], in};
        out <= {out[12:0], in[15]};
    end

endmodule