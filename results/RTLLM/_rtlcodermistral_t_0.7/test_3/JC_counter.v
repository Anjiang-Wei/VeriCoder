always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n)
         Q <= 64'd0;
      else if (Q[0] == 1'b0)
         Q <= {1'b0, Q[63:1]};
      else
         Q <= {1'b1, Q[63:1]};
   end