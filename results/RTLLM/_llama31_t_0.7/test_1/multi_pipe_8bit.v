module multi_pipe_8bit#(
    parameter size = 8
)(
          clk,      
          rst_n,       
          mul_en_in,
          mul_a, 
          mul_b, 

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

   // Register to store the input enable signal
   reg [1:0] mul_en_out_reg;

   // Registers to store the multiplicand and multiplier
   reg [size-1:0] mul_a_reg, mul_b_reg;

   // Wires to store the partial products
   wire [size-1:0] temp[8];

   // Registers to store the intermediate sum values
   reg [size*2-1:0] sum[4];

   // Register to store the final product value
   reg [size*2-1:0] mul_out_reg;

   always @(posedge clk) begin
      if (~rst_n) begin
         mul_en_out <= 1'b0;
         mul_a_reg <= 'b0;
         mul_b_reg <= 'b0;
         for (int i = 0; i < 8; i++) begin
            sum[i] <= 'b0;
         end
         mul_out_reg <= 'b0;
      end else if (mul_en_in) begin
         // Sample the input enable signal and store it in a register
         mul_en_out_reg <= mul_en_in;

         // Store the multiplicand and multiplier in their respective registers
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;

         // Generate partial products
         for (int i = 0; i < size; i++) begin
            temp[i] = (mul_b_reg[size-1-i] ? {size{mul_a_reg}} : {{size{1'b0}},mul_a_reg[size-1-i]});
         end

         // Calculate partial sums
         sum[3] <= mul_a_reg + temp[7];
         sum[2] <= mul_a_reg + temp[6];
         sum[1] <= mul_a_reg + temp[5];
         sum[0] <= mul_a_reg + temp[4];

         // Calculate final product
         for (int i = 3; i > 0; i--) begin
            mul_out_reg[i*2-1:0] <= mul_out_reg[(i-1)*2+:16] + {sum[i], sum[i]};
         end

         // Update output enable signal and product value
         mul_en_out <= |mul_en_out_reg;
         if (|mul_en_out_reg) begin
            mul_out <= mul_out_reg[size*2-1:0];
         end else begin
            mul_out <= {size*16{1'b0}};
         end
      end
   end
endmodule