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
   
   //input control
   wire [size-1:0] temp,
               mul_a_reg,
               mul_b_reg,
               mul_en_out_reg;
   
   //register to store input values
   reg[size*2-1:0] sum; 
    
   wire sum_valid;
   
   assign {mul_out[size-1:0],mul_out[size*2+1:size*2]} = mul_en_out ? (sum > 0) : ((sum == 0)?0:{temp});
         
   //generate partial products with the help of bitwise operations and conditional assignments
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n) begin
            mul_en_out <= 0; 
            sum <= 0;
            temp <= 0;
        end
        else begin
            sum <= {sum[size*1-1:0],(sum[size*2-1:size*2])}; //addition of partial products for the current size.
            if(mul_en_in) begin //enable the multiplication
                mul_a_reg<= mul_a;  //store the multiplicand to register
                mul_b_reg <= mul_b;  //store the multiplier to register
                temp[size-1:0] = sum[size*2-1:size*2];   //use bitwise operations to generate partial products.
            end
        end
    end
     
endmodule