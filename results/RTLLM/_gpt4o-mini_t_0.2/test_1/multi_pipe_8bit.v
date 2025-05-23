module multi_pipe_8bit#(
    parameter size = 8
)(
    input           clk,      
    input           rst_n,       
    input   [size-1:0] mul_a,       
    input   [size-1:0] mul_b,       
    input           mul_en_in,
    
    output reg      mul_en_out,      
    output reg [size*2-1:0] mul_out    
);

    // Internal registers
    reg [size-1:0] mul_a_reg;
    reg [size-1:0] mul_b_reg;
    reg [size*2-1:0] partial_products [0:size-1]; // Store partial products
    reg [size*2-1:0] sum [0:size-1]; // Intermediate sums
    reg [size*2-1:0] mul_out_reg;

    integer i;

    // State management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out <= 0;
            mul_out_reg <= 0;
            mul_out <= 0;
        end else begin
            // Input Control
            mul_en_out <= mul_en_in; // Latch enable signal
            if (mul_en_in) begin
                mul_a_reg <= mul_a; // Load multiplicand
                mul_b_reg <= mul_b; // Load multiplier
            end
            
            // Generate Partial Products
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b_reg[i]) begin
                    partial_products[i] <= {mul_a_reg, i}; // Shift multiplicand based on multiplier bit
                end else begin
                    partial_products[i] <= 0;
                end
            end
            
            // Summing Partial Products
            mul_out_reg = 0; // Reset accumulator
            for (i = 0; i < size; i = i + 1) begin
                mul_out_reg = mul_out_reg + partial_products[i];
            end
            
            // Store final product
            mul_out <= mul_out_reg; // Assign the accumulated result to output
        end
    end

endmodule