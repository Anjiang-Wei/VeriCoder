module multi_pipe_4bit#(
    parameter size = 4
)(
    input                   clk       ,   
    input                   rst_n     ,
    input   [size-1:0]     mul_a     ,
    input   [size-1:0]     mul_b     ,
 
    output  reg [size*2-1:0]    mul_out        
);

parameter N = 2 * size;

// Intermediate registers
reg [N-1:0] partial_product [0:size-1];
reg [N-1:0] sum_reg [0:size-1];
reg [N-1:0] final_sum;

// Generating partial products based on multiplier bits
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            partial_product[i] = mul_a << i; // Shift left by i bits
        end else begin
            partial_product[i] = {N{1'b0}};  // Zero partial product
        end
    end
end

// Sum partial products with two levels of registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // On reset, clear all registers
        final_sum <= {N{1'b0}};
        for (int j = 0; j < size; j++) begin
            sum_reg[j] <= {N{1'b0}};
        end
    end else begin
        // Adding partial products into sum_reg
        final_sum <= {N{1'b0}}; // Reset final sum for addition
        
        // First level of summation
        for (int j = 0; j < size; j++) begin
            sum_reg[j] <= final_sum + partial_product[j];
            final_sum <= sum_reg[j]; // Accumulate results
        end
        
        // Output the final product
        mul_out <= final_sum;
    end
end

endmodule