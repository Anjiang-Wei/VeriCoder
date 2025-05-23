module right_shifter(clk, q, d);

    // Port declarations
    input        clk;
    input        d;
    output [7:0] q;
    
    // Internal register for the shifting operation
    reg [7:0] q;
    
    // Initialize q to 0
    initial begin
        q = 8'b0000_0000;
    end

    // On each rising edge of the clock, perform the right shift
    // Using the >> operator to shift q by one bit and then assigning d to the MSB (q[7])
    always @(posedge clk) begin
        q <= (q >> 1);  // Shift q right by one bit; this inserts a zero in the MSB
        q[7] <= d;      // Replace the MSB with the input d
    end

endmodule