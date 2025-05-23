module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]    Q  
);
   
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         Q <= 64'b0;  // Reset the counter to 0 when rst_n is low
      end else begin
         if (Q[0] == 1'b0) begin
            // Increment by shifting right and appending 1 at the MSB
            Q <= {1'b1, Q[63:1]};
         end else if (Q[0] == 1'b1) begin
            // Decrement by shifting right and appending 0 at the MSB
            Q <= {1'b0, Q[63:1]};
         end
      end
   end
   
endmodule