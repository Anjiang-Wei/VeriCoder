module right_shifter(clk, q, d);

    input  clk;          // Clock signal
    input  d;            // Input signal to be shifted in
    output reg [7:0] q;  // 8-bit register to store the result (output)

    // Initialize the register `q` to 0
    initial begin
        q = 8'b0;
    end

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        q <= (q >> 1);   // Perform the right shift
        q[7] <= d;       // Insert the new input bit `d` into the MSB
    end

endmodule