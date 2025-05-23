module right_shifter(clk, q, d);
    input        clk;
    input        d;
    output reg [7:0] q;
    
    // Initialize the register to 0.
    initial begin
        q = 8'b00000000;
    end

    // On each rising clock edge, shift q right by 1 bit and insert input d into the MSB.
    always @(posedge clk) begin
        q <= (q >> 1);  // Right shift the entire register by one bit.
        q[7] <= d;      // Overwrite the MSB with the new input bit.
    end

endmodule