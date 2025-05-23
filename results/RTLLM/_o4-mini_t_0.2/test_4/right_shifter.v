module right_shifter (
    input        clk,
    input        d,
    output reg [7:0] q
);

    // initialize to zero
    initial
        q = 8'b0;

    // on each rising clock edge, shift right and insert d in MSB
    always @(posedge clk) begin
        q      <= (q >> 1);
        q[7]   <= d;
    end

endmodule