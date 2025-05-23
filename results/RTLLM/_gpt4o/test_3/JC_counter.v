module JC_counter(
   input                clk,
   input                rst_n,
   output reg [63:0]    Q
);

always @(posedge clk or negedge rst_n) begin
   if (!rst_n) begin
      Q <= 64'b0;  // Reset the counter to 0
   end else begin
      if (Q[0] == 0) begin
         Q <= {1'b1, Q[63:1]};  // Shift right and append 1 at MSB if LSB = 0
      end else begin
         Q <= {1'b0, Q[63:1]};  // Shift right and append 0 at MSB if LSB = 1
      end
   end
end

endmodule