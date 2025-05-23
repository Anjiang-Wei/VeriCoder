always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin 
        Q <= 64'b0;  // Reset the counter to 0
      end else begin
        Q <= {Q[62:0], ~Q[63]};  // Shift the counter to the right and append the complement of the MSB
      end
   end
endmodule