module right_shifter(clk, q, d);

    input clk;
    input d;
    output [7:0] q;

    reg [7:0] q = 0; // Initialize the register to 0

    always @(posedge clk) begin
        q <= (q >> 1); // Right-shift the value of the register by 1 bit
        q[7] <= d; // Insert the input signal into the most significant position of the register
    end

endmodule