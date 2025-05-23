module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]    Q  
);
   
   // Internal signal to hold the next state
   reg [63:0] next_state;

   // State transition logic
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         // Reset condition: set Q to 0
         Q <= 64'b0;
      end else begin
         // Update Q with next_state on every rising edge of clk
         Q <= next_state;
      end
   end

   // Determine the next state based on the current state
   always @(*) begin
      // Initialize next_state to current state
      next_state = Q;

      // If the least significant bit (Q[0]) is 0, increment the counter
      if (Q[0] == 1'b0) begin
         // Shift right and append 1 at the most significant bit
         next_state = {1'b1, Q[62:0]};
      end else begin
         // If the least significant bit (Q[0]) is 1, decrement the counter
         // Shift right and append 0 at the most significant bit
         next_state = {1'b0, Q[62:0]};
      end
   end
endmodule