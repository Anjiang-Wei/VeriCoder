module multi_pipe_8bit#(
    parameter size = 8
)(
          clk,      
          rst_n,       
          mul_a,       
          mul_b, 
          mul_en_in,
 
          mul_en_out,      
          mul_out    
);
   input clk;           
   input rst_n; 
   input mul_en_in;      
   input [size-1:0] mul_a;       
   input [size-1:0] mul_b;       
 
   output reg mul_en_out;  
   output reg [size*2-1:0] mul_out;    
   
   //input enable register
   reg[size-1:0] mul_en_out_reg=0;
   always @(posedge clk) begin 
      if(rst_n) begin 
         mul_en_out_reg<=0;
      end
       else if(mul_en_in) begin
          mul_en_out_reg<=1;//1 indicates enable operation,else disable
      end  
   end
   
   //registers for input
   reg[size-1:0] mul_a_reg=0; 
   reg[size-1:0] mul_b_reg=0; 
   
   always @(posedge clk) begin 
      if(rst_n) begin 
         mul_a_reg<=0;
         mul_b_reg<=0;
      end 
       else if(mul_en_in) begin //wait for active-low signal to turn on
          mul_a_reg<=mul_a;
          mul_b_reg<=mul_b;
      end  
   end   
  
   wire[size*2-1:0] temp=0; 
   always @(posedge clk) begin
      if(rst_n) begin 
         for(i=0;i<8;i=i+1) begin
            temp[i]=0;
         end 
      end
       else if(mul_en_in) begin   //do bitwise operation on the temp wire
          temp[size-1:0]={{mul_a,mul_b}.*{{size,1)}};//output of {mul_a,mul_b}.*{{size,1}} is sum of bits 0 to size-1 from mul_a with bits 0 to size-1 from mul_b
          temp[size-2:1]={{mul_a,mul_b}.* {{size+1,1}}} //output of {mul_a,mul_b}.*{{size+1,1}} is sum of bits 1 to size from mul_a with bits 0 to size-1 from mul_b
          temp[size-3:2]={{mul_a,mul_b}.* {{size+2,1}}} //output of {mul_a,mul_b}.*{{size+2,1}} is sum of bits 2 to size+1 from mul_a with bits 0 to size-1 from mul_b
          temp[size-4:3]={{mul_a,mul_b}.* {{size+3,1}}} //output of {mul_a,mul_b}.*{{size+3,1}} is sum of bits 3 to size+2 from mul_a with bits 0 to size-1 from mul_b
          temp[size-5:4]={{mul_a,mul_b}.* {{size+4,1}}} //output of {mul_a,mul_b}.*{{size+4,1}} is sum of bits 4 to size+3 from mul_a with bits 0 to size-1 from mul_b
          temp[size-6:5]={{mul_a,mul_b}.* {{size+5,1}}} //output of {mul_a,mul_b}.*{{size+5,1}} is sum of bits 5 to size+4 from mul_a with bits 0 to size-1 from mul_b
          temp[size-7:6]={{mul_a,mul_b}.* {{size+6,1}}} //output of {mul_a,mul_b}.*{{size+6,1}} is sum of bits 6 to size+5 from mul_a with bits 0 to size-1 from mul_b
          temp[size-8:7]={{mul_a,mul_b}.* {{size+7,1}}} //output of {mul_a,mul_b}.*{{size+7,1}} is sum of bits 7 to size+6 from mul_a with bits 0 to size-1 from mul_b
       end
   end 
   
   assign mul_out=temp;//use temp for the output register,size*2 bits
      //output register will be 0 if no multiplying operation occured and 1 otherwise.
endmodule