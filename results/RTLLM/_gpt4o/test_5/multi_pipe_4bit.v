module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk       ,  
    input                       rst_n     ,
    input   [size-1:0]          mul_a     ,
    input   [size-1:0]          mul_b     ,
 
    output  reg [size*2-1:0]    mul_out     
);

parameter N = 2 * size;

// Intermediate registers for pipeline stages
reg [N-1:0] partial_product [size-1:0];  // Array for partial products
reg [N-1:0] sum_stage1;                  // Intermediate sum after the first stage
reg [N-1:0] sum_stage2;                  // Intermediate sum after the second stage

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all intermediate and output registers
        mul_out       <= 0;
        sum_stage1    <= 0;
        sum_stage2    <= 0;
        for (i = 0; i < size; i = i + 1) begin
            partial_product[i] <= 0;
        end
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i] == 1'b1) begin
                // Left shift multiplicand by the bit index
                partial_product[i] <= {mul_a, {i{1'b0}}};
            end else begin
                partial_product[i] <= 0;
            end
        end
        
        // First pipeline stage: Add partial products [0] and [1]
        sum_stage1 <= partial_product[0] + partial_product[1];
        
        // Second pipeline stage: Add remaining partial products
        sum_stage2 <= partial_product[2] + partial_product[3];
        
        // Final stage: Summing stage outputs for final product
        mul_out <= sum_stage1 + sum_stage2;
    end
end

endmodule