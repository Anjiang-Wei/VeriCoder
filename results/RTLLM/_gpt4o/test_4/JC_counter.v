module JC_counter(
   input                clk ,   // Clock signal
   input                rst_n,  // Active-low reset signal
   output reg [63:0]    Q       // 64-bit Register Output
);

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         Q <= 64'b0;  // Reset to all 0s when rst_n is low
      end else begin
         if (Q[0] == 0) begin
            Q <= {1'b1, Q[63:1]};  // Shift Right and append '1' at MSB
         end else begin
            Q <= {1'b0, Q[63:1]};  // Shift Right and append '0' at MSB
         end
      end
   end

endmodule