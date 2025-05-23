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
   reg[size-1:0] temp[size];    //for bit-wise operator
   reg[size*2-1:0] sum[size/2];  //register for partial sum, where size is a power of two.
 
//Registers to store the input values and used to generate the output enable signal.
assign mul_en_out = {size{mul_en_in}};
reg[size-1:0] mul_a_reg;   //register for input values
reg[size-1:0] mul_b_reg;  //register for input values
//register used to generate the output enable signal.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_out <= 0;
        mul_a_reg <= 'd0;
        mul_b_reg <= 'd0;
    end
    else begin
        mul_en_out <= mul_en_in;
        mul_a_reg <= {mul_a}; //the last bit is used as the active low register. 
        mul_b_reg <= {mul_b};
    end
end

//registers to store the intermediate partial products, where size is a power of two, and then added up to generate the final product.
assign temp[size-1:0] = (mul_a_reg * "d1") + mul_b_reg; //bitwise operator with register as the operand.
assign sum[size/2-1:0] = temp[7:0];  //register for partial sum, where size is a power of two.
//register to store the final product.
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) mul_out <= 'd0;
    else begin
        if(mul_en_out) mul_out <= sum[size/2-1:0];  //register for final product.
        else mul_out <= 'd0;
    end
end

endmodule