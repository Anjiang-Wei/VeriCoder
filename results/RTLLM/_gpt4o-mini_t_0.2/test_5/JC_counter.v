module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]   Q  
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        Q <= 64'b0;
    end else begin
        // Johnson counter logic
        if (Q[0] == 0) begin
            // Shift right and insert 1 at the MSB
            Q <= {1'b1, Q[63:1]};
        end else begin
            // Shift right and insert 0 at the MSB
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule