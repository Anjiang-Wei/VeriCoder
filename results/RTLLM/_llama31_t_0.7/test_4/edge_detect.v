module edge_detect(
    input  wire        clk,           // Clock signal
    input  wire        rst_n,         // Reset signal (active low)
    input  wire        a,             // Input signal
    
    output reg         rise,          // Output signal indicating a rising edge
    output reg         down           // Output signal indicating a falling edge
);

// Internal registers to store the previous value of 'a'
reg prev_a;

initial begin
    // Initialize 'prev_a' to the initial value of 'a'
    prev_a = 1'b0;
end

always @(posedge clk) begin
    if (~rst_n) begin
        rise <= 1'b0;
        down <= 1'b0;
        prev_a <= a;
    end else begin
        // Detect rising edge
        if (a & ~prev_a)
            rise <= 1'b1;

        // Detect falling edge
        if (~a & prev_a)
            down <= 1'b1;

        // Reset 'rise' and 'down' to 0 on next clock cycle after an edge is detected
        rise <= a ^ prev_a ? 1'b0 : rise;
        down <= ~a && prev_a ? 1'b0 : down;

        // Store the current value of 'a'
        prev_a <= a;
    end
end

endmodule