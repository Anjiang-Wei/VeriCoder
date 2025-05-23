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

reg [size-1:0] mul_a_reg, mul_b_reg;
reg [size-1:0] mul_en_out_reg;
wire [size-1:0] mul_a_wire, mul_b_wire;
wire [size*2-1:0] partial_products [size-1:0];
reg [size*2-1:0] sum [size-1:0];
reg [size*2-1:0] mul_out_reg;

// Input Control: Sample input enable signal and store in register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
    end
end

// Input Registers: Sample input values and store in registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Partial Product Generation: Generate partial products based on multiplier bits
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : pp_gen
        assign partial_products[i] = {mul_a_reg, {size-1{1'b0}}} & {mul_b_reg[i], {size-1{1'b0}}};
    end
endgenerate

// Partial Sum Calculation: Sum partial products to get intermediate sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i = i + 1) begin
            sum[i] <= 0;
        end
    end else begin
        sum[0] <= partial_products[0];
        for (i = 1; i < size; i = i + 1) begin
            sum[i] <= sum[i-1] + partial_products[i];
        end
    end
end

// Final Product Calculation: Sum all partial sums to get the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= sum[size-1];
    end
end

// Output Assignment: Assign output product based on output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        mul_en_out <= mul_en_out_reg[0];
        if (mul_en_out_reg[0]) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end
end

endmodule