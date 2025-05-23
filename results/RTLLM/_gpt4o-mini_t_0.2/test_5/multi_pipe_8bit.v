module multi_pipe_8bit #(
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

    reg mul_en_out_reg;
    reg [size-1:0] mul_a_reg;
    reg [size-1:0] mul_b_reg;
    reg [size*2-1:0] partial_product [0:size-1];
    reg [size*2-1:0] sum [0:size-1];
    reg [size*2-1:0] mul_out_reg;
    integer i;

    // Multiplication process divided into several stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 1'b0;
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_out_reg <= 0;
            mul_en_out <= 1'b0;
        end else begin
            // Input control
            mul_en_out_reg <= mul_en_in;
            mul_en_out <= mul_en_out_reg;

            // Register the inputs on mul_en_in
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Generate partial products
            for (i = 0; i < size; i = i + 1) begin
                partial_product[i] = mul_a_reg & {size{mul_b_reg[i]}};
            end

            // Calculate partial sums
            sum[0] <= partial_product[0];
            for (i = 1; i < size; i = i + 1) begin
                sum[i] <= sum[i-1] + partial_product[i];
            end

            // Final product calculation
            mul_out_reg <= sum[size-1];

            // Assign output
            if (mul_en_out_reg) begin
                mul_out <= mul_out_reg;
            end else begin
                mul_out <= 16'b0;
            end
        end
    end
endmodule