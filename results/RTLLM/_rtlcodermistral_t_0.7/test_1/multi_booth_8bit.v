```verilog
   reg [15:0] multiplier, multiplicand;
   reg [4:0] ctr;
   reg [15:0] p_reg;
   wire [15:0] p_wire;
   assign p_wire = p_reg;
   assign rdy = ctr == 16;

   always @(posedge clk, posedge reset) begin
      if (reset) begin
         multiplier <= {{8{a[7]}}, a};
         multiplicand <= {{8{b[7]}}, b};
         ctr <= 0;
         p_reg <= 0;
      end
      else begin
         if (ctr < 16) begin
            if (multiplier[ctr]) begin
               multiplicand <= {multiplicand[14:0], 1'b0};
               p_reg <= p_reg + multiplicand;
            end
            multiplicand <= {multiplicand[14:0], multiplicand[0]};
            ctr <= ctr + 1;
         end
         else begin
            rdy <= 1;
         end
      end
   end

   assign p = p_wire;

endmodule