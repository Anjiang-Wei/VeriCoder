module JC_counter(
   input                clk ,
   input                rst_n,
   output reg [63:0]     Q  
);
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         Q <= 64'b0; // Reset the counter to 0
      end
      else if (Q[0] == 1'b0) begin
         Q <= {Q[62:0], 1'b1}; // Increment by appending 1
      end
      else if (Q[0] == 1'b1) begin
         Q <= {Q[62:0], 1'b0}; // Decrement by appending 0
      end
   end
endmodule