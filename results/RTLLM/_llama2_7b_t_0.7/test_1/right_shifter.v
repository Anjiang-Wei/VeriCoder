module right_shifter(clk, q, d);

    input clk;
    input d;
    output [7:0] q;

    always @(posedge clk) begin
        // Shift the value of q to the right by one bit
        q <= (q >> 1);

        // Set the most significant bit of q to the input signal d
        q[7] <= d;
    end

endmodule