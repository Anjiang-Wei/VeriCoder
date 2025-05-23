// Module definition
module JC_counter(
   input                clk ,  // Clock signal used for synchronous operation.
   input                rst_n, // Active-low reset signal to initialize the counter.

   output reg [63:0]     Q      // 64-bit register representing the current count value.
);

// Reset logic
always @(posedge rst_n) begin
   if (!rst_n) begin
      Q <= '0; // Reset counter value to 0 when reset signal is low.
   end
end

// Counter increment/decrement logic
always @ (posedge clk or posedge rst_n) begin
   if (rst_n) begin
      Q <= '0;
   end else begin
      case (Q[63])
         1'b0: // If the least significant bit is 0, increment counter.
            Q[62:0] <= {1'b0, Q[61:0]};
            Q[63] <= 1'b1;

         1'b1: // If the least significant bit is 1, decrement counter.
            Q[62:0] <= {1'b1, Q[61:0]};
            Q[63] <= 1'b0;
      endcase
   end
end

endmodule // End of JC_counter module definition.