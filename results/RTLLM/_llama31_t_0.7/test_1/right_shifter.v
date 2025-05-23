module right_shifter(
    input  clk,
    input  d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (q == 8'b00000000) begin // if q is initialized to zero
        q <= {d, 7'b0000000};
    else begin
        q <= {1'b0, q[7:1]};
    end
end

initial q = 8'b00000000;

endmodule