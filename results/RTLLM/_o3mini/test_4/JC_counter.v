module JC_counter(
    input             clk,
    input             rst_n,
    output reg [63:0] Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'd0;
    else if (Q[0] == 1'b0)
        // Increment mode: shift right and insert a 1 at MSB.
        Q <= {1'b1, Q[63:1]};
    else
        // Decrement mode: shift right and insert a 0 at MSB.
        Q <= {1'b0, Q[63:1]};
end

endmodule