module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]    Q  
);
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         Q <= 64'b0;  // Reset condition: set Q to 0
      end else begin
         if (Q[0] == 1'b0) begin
            // Increment: Shift right and append 1 at the most significant bit
            Q <= {1'b1, Q[63:1]};
         end else if (Q[0] == 1'b1) begin
            // Decrement: Shift right and append 0 at the most significant bit
            Q <= {1'b0, Q[63:1]};
         end
      end
   end
   
endmodule