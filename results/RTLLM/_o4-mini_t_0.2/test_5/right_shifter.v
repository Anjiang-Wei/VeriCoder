module right_shifter(clk, q, d);

    input        clk;
    input        d;
    output [7:0] q;
    reg    [7:0] q;

    // initialize the shift register to 0
    initial begin
        q = 8'b0;
    end

    // on each rising clock edge, shift right and insert d at MSB
    always @(posedge clk) begin
        q      <= (q >> 1);
        q[7]   <= d;
    end

endmodule