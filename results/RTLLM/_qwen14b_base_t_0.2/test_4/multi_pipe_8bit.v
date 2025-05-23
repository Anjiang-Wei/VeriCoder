module multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,           
    input rst_n,         
    input mul_en_in,      
    input [size-1:0] mul_a,       
    input [size-1:0] mul_b,       
    output reg mul_en_out,      
    output reg [size*2-1:0] mul_out    
);
   
   // Internal registers
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg [size-1:0] mul_en_out_reg;
   reg [size*2-1:0] mul_out_reg;
   
   // Internal wires for partial products
   wire [size*2-1:0] temp [0:size-1];
   
   // Internal registers for partial sums
   reg [size*2-1:0] sum [0:size-1];
   
   // Input Control
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out_reg <= 0;
      end else begin
         mul_en_out_reg <= mul_en_in;
      end
   end
   
   // Input Registers
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_a_reg <= 0;
         mul_b_reg <= 0;
      end else if (mul_en_in) begin
         mul_a_reg <= mul_a;
         mul_b_reg <= mul_b;
      end
   end
   
   // Partial Product Generation
   generate
      genvar i;
      for (i = 0; i < size; i = i + 1) begin
         assign temp[i] = (mul_b_reg[i] == 1'b1) ? {mul_a_reg, {size-1{1'b0}}} : {size*2{1'b0}};
      end
   endgenerate
   
   // Partial Sum Calculation
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         for (int j = 0; j < size; j = j + 1) begin
            sum[j] <= 0;
         end
      end else begin
         sum[0] <= temp[0];
         for (int j = 1; j < size; j = j + 1) begin
            sum[j] <= sum[j-1] + temp[j];
         end
      end
   end
   
   // Final Product Calculation
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_out_reg <= 0;
      end else begin
         mul_out_reg <= sum[size-1];
      end
   end
   
   // Output Assignment
   always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         mul_en_out <= 0;
         mul_out <= 0;
      end else begin
         mul_en_out <= mul_en_out_reg[size-1];
         if (mul_en_out_reg[size-1]) begin
            mul_out <= mul_out_reg;
         end else begin
            mul_out <= 0;
         end
      end
   end
   
endmodule