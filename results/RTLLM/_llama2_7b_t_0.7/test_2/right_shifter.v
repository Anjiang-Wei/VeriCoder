module right_shifter(clk, q, d);

    input clk;
    input d;
    output [7:0] q;

    reg [7:0] q = 0; // Initialize register to 0

    always @(posedge clk) begin
        q <= (q >> 1); // Right-shift the value of q by one bit
        q[7] <= d; // Assign the input signal to the most significant bit of the register
    end

endmodule