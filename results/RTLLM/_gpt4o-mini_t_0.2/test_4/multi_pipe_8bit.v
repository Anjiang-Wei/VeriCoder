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

    reg mul_en_out_reg;
    reg [size-1:0] mul_a_reg, mul_b_reg;
    reg [size*2-1:0] partial_product [0:size-1];
    reg [size*2-1:0] sum [0:size-1];
    reg [size*2-1:0] mul_out_reg;
    integer i;

    // Input Control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out <= 0;
            mul_out_reg <= 0;
        end else begin
            mul_en_out_reg <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_out <= mul_en_out_reg;
        end
    end

    // Partial Product Generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1) begin
                partial_product[i] <= 0;
                sum[i] <= 0;
            end
        end else if (mul_en_in) begin
            // Generate partial products based on the multiplier bits
            for (i = 0; i < size; i = i + 1) begin
                partial_product[i] <= (mul_b_reg[i] ? {mul_a_reg, i} : 0);
            end
        end
    end

    // Partial Sum Calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_out_reg <= 0;
            for (i = 0; i < size; i = i + 1) begin
                mul_out_reg <= mul_out_reg + partial_product[i];
            end
        end
    end

    // Final Product Assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= (mul_en_out) ? mul_out_reg : 0;
        end
    end
endmodule