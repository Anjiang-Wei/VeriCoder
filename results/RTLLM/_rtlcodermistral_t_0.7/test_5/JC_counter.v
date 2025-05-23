```verilog
   always @(posedge clk, negedge rst_n)
   begin
      if(!rst_n)
         Q <= 0;
      else
         if(Q[0] == 0)
            Q <= {Q[62:0], 1'b1};
         else
            Q <= {Q[62:0], 1'b0};
   end
endmodule