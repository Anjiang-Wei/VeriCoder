module multi_pipe_8bit#(parameter size = 8)(
    input clk,      
    input rst_n,       
    input mul_en_in,      
    input [size-1:0] mul_a,       
    input [size-1:0] mul_b, 
    output reg mul_en_out,      
    output reg [size*2-1:0] mul_out    
);
   // Input Control
   always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            mul_en_out <= 0;
            mul_out <= 0;
        end else if (mul_en_in) begin
            mul_en_out <= 1;
            mul_out <= mul_a * mul_b;
        end else begin
            mul_en_out <= 0;
            mul_out <= 0;
        end
   end
   
   // Input Registers
   always @(*) begin
       mul_a_reg <= mul_a;
       mul_b_reg <= mul_b;
   end
   
   // Partial Product Generation
   wire [size-1:0] temp = {mul_a, mul_b};
   always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            temp <= 0;
        end else begin
            temp[size-1] <= temp[size-2];
            temp[size-2] <= temp[size-3];
            // ...
            temp[0] <= temp[size-1];
        end
   end
   
   // Partial Sum Calculation
   always @(*) begin
       sum[size/2-1:0] <= 0;
       for (int i = size/2-1; i >= 0; i--) begin
           sum[i] <= temp[i];
       end
   end
   
   // Final Product Calculation
   always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum[size*2-1:size/2];
        end
   end
   
   // Output Assignment
   always @(*) begin
       if (mul_en_out) begin
           mul_out <= mul_out + 1;
       end else begin
           mul_out <= 0;
       end
   end