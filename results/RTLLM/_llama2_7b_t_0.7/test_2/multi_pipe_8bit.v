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
      if (rst_n == 1'b0) begin
         mul_en_out <= 0;
      end else begin
         if (mul_en_in === 1'b1) begin
            mul_en_out <= 1;
         end else begin
            mul_en_out <= 0;
         end
      end
   end
   
   // Input Registers
   always @* begin
      mul_a_reg <= {mul_a};
      mul_b_reg <= {mul_b};
   end
   
   // Partial Product Generation
   always @(posedge clk or posedge rst_n) begin
      case (size)
        2: begin
            temp[0] <= mul_a[0] * mul_b[0];
            temp[1] <= mul_a[1] * mul_b[1];
            // ...
            temp[size-2] <= mul_a[size-2] * mul_b[size-2];
            temp[size-1] <= mul_a[size-1] * mul_b[size-1];
         end
        3: begin
            temp[0] <= mul_a[0] * mul_b[0];
            temp[1] <= mul_a[1] * mul_b[1];
            // ...
            temp[2] <= mul_a[2] * mul_b[2];
         end
        // ...
      endwires
   end
   
   // Partial Sum Calculation
   always @(posedge clk or posedge rst_n) begin
      for (int i = 0; i < size; i++) begin
         sum[i] <= temp[i];
      end
   end
   
   // Final Product Calculation
   always @(posedge clk or posedge rst_n) begin
      if (rst_n == 1'b0) begin
         mul_out <= 0;
      end else begin
         mul_out <= sum[size-1];
      end
   end
   
   // Output Assignment
   always @* begin
      if (mul_en_out === 1'b1) begin
         mul_out <= temp[size*2-1];
      end else begin
         mul_out <= 0;
      end
   end