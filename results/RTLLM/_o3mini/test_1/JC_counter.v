module JC_counter(
   input                clk,
   input                rst_n,
   output reg [63:0]    Q  
);

always @(posedge clk or negedge rst_n) begin
   if (!rst_n)
      Q <= 64'b0;  // On reset, set Q to 0
   else begin
      // If LSB is 0: shift right and append a 1 at the MSB
      // If LSB is 1: shift right and append a 0 at the MSB
      if (Q[0] == 1'b0)
         Q <= {1'b1, Q[63:1]};
      else
         Q <= {1'b0, Q[63:1]};
   end
end

endmodule