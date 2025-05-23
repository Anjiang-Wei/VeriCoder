```verilog
   always @(posedge clk or negedge rst_n)
   begin
      if (~rst_n) begin
         Q <= 0;
      end
      else begin
         if (Q[0] == 0) begin
            Q <= {1'b1, Q[63:1]};
         end
         else begin
            Q <= {1'b0, Q[63:1]};
         end
      end
   end

endmodule