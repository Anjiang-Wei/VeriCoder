module right_shifter (
    input        clk,
    input        d,
    output [7:0] q
);

    // output register
    reg [7:0] q;

    // initialize shift register to zero
    initial begin
        q = 8'b0;
    end

    // on each rising edge, shift right by one,
    // then insert new bit 'd' into MSB position
    always @(posedge clk) begin
        q       <= (q >> 1);
        q[7]    <= d;
    end

endmodule