module right_shifter(
    input  clk,
    input  d,
    output reg [7:0] q
);

initial begin
    q = 8'b00000000; // Initialize register to 0
end

always @(posedge clk) begin
    q <= {q[6], q[5], q[4], q[3], q[2], q[1], q[0], d};
end

endmodule