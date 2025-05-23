module right_shifter(clk, q, d);

    input        clk;
    input        d;
    output [7:0] q;
    reg    [7:0] q;

    // initialize register to 0
    initial q = 8'b0;

    // on each rising clock edge, shift right and insert new bit at MSB
    always @(posedge clk) begin
        q <= (q >> 1);
        q[7] <= d;
    end

endmodule