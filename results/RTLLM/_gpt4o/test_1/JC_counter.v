module JC_counter(
   input                clk,
   input                rst_n,
   output reg [63:0]    Q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset active-low: set counter to 0 when rst_n is low
        Q <= 64'b0;
    end else begin
        // Update the state of the Johnson counter
        if (Q[0] == 1'b0) begin
            // Shift and append 1 to the MSB if LSB is 0
            Q <= {1'b1, Q[63:1]}; 
        end else begin
            // Shift and append 0 to the MSB if LSB is 1
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule