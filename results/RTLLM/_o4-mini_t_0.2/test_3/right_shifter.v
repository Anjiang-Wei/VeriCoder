module right_shifter(clk, q, d);

    input        clk;
    input        d;
    output [7:0] q;
    reg    [7:0] q;

    // initialize the shift register to zero
    initial begin
        q = 8'b0000_0000;
    end

    // on every rising edge, shift right and insert d at MSB
    always @(posedge clk) begin
        q <= (q >> 1);
        q[7] <= d;
    end

endmodule