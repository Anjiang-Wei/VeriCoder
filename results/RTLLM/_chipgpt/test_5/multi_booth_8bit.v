module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;
 
   wire [15:0] multiplier, multiplicand; 
    //Multiplication of 8-bit binary digits
   always @(posedge clk or posedge reset) begin
       if (reset) begin
           multiplier <= {{8{a[7]}}, a};
           multiplicand <= {{8{b[7]}}, b};
        end
       else begin
            if (ctr == 16) begin
                p <= multiplicand;
                rdy <= 1;   //Ready signal to indicate that multiplication is completed.
            end
            else if(a[ctr] && b[ctr]) begin
                    p <= {multiplier[15:0], multiplicand};
            end
            
            else begin
               multiplicand <<= 1;
            end
       end
   end
endmodule