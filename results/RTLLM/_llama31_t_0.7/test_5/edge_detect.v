module edge_detect(
    input  clk,         // Clock signal
    input  rst_n,       // Reset signal (active low)
    input  a,           // Input signal
    
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg prev_a;             // Previous value of input signal 'a'
always @ (posedge clk) begin
    if (~rst_n) begin
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        prev_a <= a;     // Store current value of input signal 'a' for next cycle
        if (a && ~prev_a) begin
            rise <= 1'b1; // Set rise to 1 when a rising edge is detected
            down <= 1'b0;
        end else if (~a && prev_a) begin
            down <= 1'b1; // Set down to 1 when a falling edge is detected
            rise <= 1'b0;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule