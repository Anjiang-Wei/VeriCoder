module JC_counter(
   input                clk,    // Clock signal
   input                rst_n,  // Active-low reset signal

   output reg [63:0]    Q       // 64-bit Johnson counter output
);

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         // When reset is active, initialize the counter to 0
         Q <= 64'b0;
      end else begin
         // Update Johnson Counter logic
         if (Q[0] == 1'b0) begin
            // If LSB is 0, shift right and set MSB to 1
            Q <= {1'b1, Q[63:1]};
         end else begin
            // If LSB is 1, shift right and set MSB to 0
            Q <= {1'b0, Q[63:1]};
         end
      end
   end

endmodule