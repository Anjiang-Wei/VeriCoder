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
   
   // Internal registers
   reg [size-1:0] mul_a_reg;
   reg [size-1:0] mul_b_reg;
   reg mul_en_out_reg;
   reg [size*2-1:0] partial_sum [0:size]; // To store partial products
   integer i;

   // Reset and input capture process
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           mul_a_reg <= 0;
           mul_b_reg <= 0;
           mul_en_out_reg <= 0;
           mul_out <= 0;
       end else begin
           mul_en_out_reg <= mul_en_in;
           if (mul_en_in) begin
               mul_a_reg <= mul_a;
               mul_b_reg <= mul_b;
           end
       end
   end

   // Partial product generation
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           for (i = 0; i <= size; i = i + 1) begin
               partial_sum[i] <= 0;
           end
       end else begin
           // Calculate partial products
           for (i = 0; i < size; i = i + 1) begin
               if (mul_b_reg[i]) begin
                   partial_sum[i] <= {mul_a_reg, i}; // Shift multiplicand by i positions
               end else begin
                   partial_sum[i] <= 0;
               end
           end
       end
   end

   // Final product calculation
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           mul_out <= 0;
       end else begin
           mul_out <= 0;
           for (i = 0; i < size; i = i + 1) begin
               mul_out <= mul_out + partial_sum[i];
           end
       end
   end

   // Assign output enable based on internal register
   always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
           mul_en_out <= 0;
       end else begin
           mul_en_out <= mul_en_out_reg; // Output enable follows input enable
       end
   end

endmodule