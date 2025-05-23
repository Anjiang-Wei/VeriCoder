module multi_pipe_4bit#(
    parameter size = 4
)(
    input                   clk         ,   
    input                   rst_n       ,
    input   [size-1:0]     mul_a       ,
    input   [size-1:0]     mul_b       ,
    
    output  reg [2*size-1:0] mul_out       
);

parameter N = 2 * size;

// Intermediate register to hold partial products
reg [N-1:0] partial_products [0:size-1]; // Array to hold the partial products
reg [N-1:0] sum_reg;                       // Register to hold current sum of partial products
reg [N-1:0] final_sum;                     // Register to hold final product value

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the registers to zero
        sum_reg <= {N{1'b0}};
        final_sum <= {N{1'b0}};
        mul_out <= {N{1'b0}};
    end else begin
        // Compute partial products
        for (i = 0; i < size; i = i + 1) begin
            if (mul_b[i]) begin
                partial_products[i] <= {mul_a, {i{1'b0}}}; // Left shift multiplicand by i
            end else begin
                partial_products[i] <= {N{1'b0}}; // Set to zero
            end
        end
        
        // Accumulate partial products
        sum_reg <= {N{1'b0}}; // Initialize sum_reg for accumulation
        
        for (i = 0; i < size; i = i + 1) begin
            sum_reg = sum_reg + partial_products[i]; // Sum all partial products
        end
        
        // Update final product
        final_sum <= sum_reg;
        mul_out <= final_sum; // Output final product
    end
end

endmodule