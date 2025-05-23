module multi_pipe_4bit#(
    parameter size = 4
)(
    input                      clk       ,   
    input                      rst_n     ,
    input      [size-1:0]     mul_a     ,
    input      [size-1:0]     mul_b     ,
    
    output reg [2*size-1:0]   mul_out        
);

parameter N = 2 * size;

// Intermediate Registers
reg [N-1:0] partial_products [size-1:0]; // Stores partial products
reg [N-1:0] sum_reg; // To hold intermediate sum

// Generate partial products
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b[i]) 
            partial_products[i] = {mul_a, i}; // Left shift mul_a by i positions
        else 
            partial_products[i] = {N{1'b0}}; // Set to zero
    end
end

// Add the partial products in a pipelined fashion
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= {N{1'b0}}; // Reset sum register to 0
        mul_out <= {N{1'b0}}; // Reset output product to 0
    end else begin
        sum_reg <= partial_products[0] + 
                   partial_products[1] + 
                   partial_products[2] + 
                   partial_products[3]; // Accumulate the sum of partial products
        mul_out <= sum_reg; // Update output product
    end
end

endmodule