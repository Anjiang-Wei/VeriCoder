module right_shifter(clk, q, d);
    input        clk;
    input        d;
    output [7:0] q;
    reg    [7:0] q;

    // Initialize q to 0 at time zero.
    initial begin
        q = 8'b0;
    end

    // On every rising edge of clk perform a right shift and 
    // insert input d at the most-significant bit.
    always @(posedge clk) begin
        // Right shift the entire register by 1 bit.
        q <= (q >> 1);
        // Overwrite the most significant bit with the new input.
        q[7] <= d;
    end

endmodule