module right_shifter(clk, q, d);

    input clk;
    input d;
    output [7:0] q;

    always @(posedge clk) begin
        q <= (q >> 1); // shift the value of q to the right by one bit
        q[7] <= d; // assign the value of d to the most significant bit of q
    end

endmodule