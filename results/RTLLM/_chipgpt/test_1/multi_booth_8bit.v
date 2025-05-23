module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

   wire[15:0] multiplier, multiplicand, r_signal;
   reg[4:0] ctr; //counter used to simulate shifting operation(0-8)
   
   //registers of the multiplier
   assign multiplier = {{8{a[7]}}, a}; //multiply 2-bit value (a[7]) with 8-bit vector a
   assign multiplicand = {{8{b[7]}}, b};// multiply 2-bit value(b[7]) with 8-bit vector b
   
   //registers of the ready signal r_signal(1-16)
   always @(posedge clk or posedge reset) begin
      if(reset) r_signal <= 0;
      else r_signal <= ctr > 15 ? 0 : (r_signal == 8'd15)? 1'b1: r_signal + 1'b1; //if ctr is less than 16, it will be left-shifted by one
   end
   
   
   always @* begin
      p[15:0] = 0;
      rdy <= 0;
      
      if(r_signal == 1'b1) begin //if the counter is equal to 16, which means ctr is less than 16. Here the multiplication is performed
         p[15:8] = multiplicand[15:8];//multiplication of register multiplicand and register multiplier are performed here
         
         if(multplier[7]) //if the current bit of multpiler (moultpiler[7]) is 1, which represents a positive Booth encoding. Then the product is calculated
            p[7:0] = r_signal*8'd1 + p[7:0];//addition with register multiplicand and ready signal(r_signal) is performed here
             
          else //if the current bit of multpiler (moultpiler[7]) is 0, which represents a negative Booth encoding. Then the product is calculated by subtracting r_signal from multiplier
            p[7:0] = ~r_signal - ~multpiler[7:0]; //addition with register multiplicand and ready signal(r_signal)is performed here
      end
   end
endmodule