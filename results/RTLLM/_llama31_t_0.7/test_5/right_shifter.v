module right_shifter(
    input  clk,
    input  d,
    output reg [7:0] q
);

initial begin
    q = 8'b00000000; // Initialize q register to all zeros
end

always @(posedge clk) begin
    if (q[7] == 1) begin
        q <= {1'b0, q[6:0]};
    end else begin
        q <= {1'b1, q[6:0]};
    end
end