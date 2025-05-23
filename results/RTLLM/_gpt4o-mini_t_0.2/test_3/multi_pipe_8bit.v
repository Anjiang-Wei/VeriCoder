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
    
    // Intermediate signals
    reg [size-1:0] mul_a_reg;  
    reg [size-1:0] mul_b_reg;  
    reg mul_en_out_reg;   
    
    reg [size*2-1:0] partial_sums [0:size-1]; // Partial sums array
    reg [size*2-1:0] mul_out_reg;               // Product register
    
    // Generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0; 
            mul_b_reg <= 0; 
            mul_en_out_reg <= 0;
            mul_out_reg <= 0;
            mul_en_out <= 0; 
        end else begin
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
                mul_en_out_reg <= 1;
            end
        end
    end
    
    // Generate partial products and store into partial_sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
            mul_en_out <= 0;
            // Clear all partial sums
            for (integer i = 0; i < size; i = i + 1) begin
                partial_sums[i] <= 0;
            end
        end else begin
            if (mul_en_out_reg) begin
                // Generate partial products
                mul_out_reg <= 0; // Reset the product accumulator
                for (integer i = 0; i < size; i = i + 1) begin
                    if (mul_b_reg[i]) begin
                        partial_sums[i] <= mul_a_reg << i; // Shift `mul_a` left by `i`
                    end else begin
                        partial_sums[i] <= 0; // No contribution if b[i] is 0
                    end
                end
                
                // Calculate the final product
                for (integer i = 0; i < size; i = i + 1) begin
                    mul_out_reg <= mul_out_reg + partial_sums[i];
                end
                mul_en_out <= 1; // Indicate that the multiplication is done
            end else begin
                mul_en_out <= 0; // Disable output enable if not ready
            end
        end
    end

    // Final product assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0; // Reset output
        end else if (mul_en_out) begin
            mul_out <= mul_out_reg; // Assign product if enabled
        end else begin
            mul_out <= 0; // Set product to 0 if not enabled
        end
    end
    
endmodule