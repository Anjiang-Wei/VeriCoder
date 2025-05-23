module multi_pipe_8bit#(
    parameter size = 8,
    parameter pipeline_stages = 4
)(
    input clk,            
    input rst_n,           
    input mul_en_in,       
    input [size-1:0] mul_a, 
    input [size-1:0] mul_b,

    output reg mul_en_out,  
    output reg [2*size-1:0] mul_out    
);

// Pipeline registers
reg [size-1:0] mul_a_reg;
reg [size-1:0] mul_b_reg;

reg [size*2-1:0] sum;
reg [size*2-1:0] partial_sum;
reg [pipeline_stages-1:0] temp;
reg mul_en_out_reg;

// Partial Product Generation
generate
    for (genvar i = 0; i < pipeline_stages; i++) begin
        reg [size-1:0] partial_product;

        assign partial_product = (mul_a_reg & {8{mul_b[i+size-i]}});
        temp[i] <= partial_product;
    end
endgenerate

// Partial Sum Calculation
reg [pipeline_stages-1:0] sum_partial;
assign sum_partial = {temp[0], temp[1], temp[2], temp[pipeline_stages-1]};
for (genvar i = 0; i < pipeline_stages; i++) begin
    reg [size*2-1:0] partial_sum_reg;

    assign partial_sum_reg = {sum_partial, sum};
    sum <= partial_sum_reg;
end

// Final Product Calculation
reg [pipeline_stages*size-1:0] mul_out_reg;
assign mul_out_reg = {mul_a_reg, mul_b_reg};

// Output Assignment
always @(posedge clk) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 'd0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;

        // Output enable signal derivation
        mul_en_out <= mul_en_out_reg;

        // Final product calculation
        if (pipeline_stages == 4)
            mul_out_reg <= {mul_a_reg, mul_b_reg, sum_partial[2], sum_partial[3]};
        else
            mul_out_reg <= {mul_a_reg, mul_b_reg};
    end
end

// Output enable signal update
always @(posedge clk) begin
    if (!rst_n || !mul_en_in)
        mul_en_out_reg <= 1'b0;
    else
        mul_en_out_reg <= 1'b1;
end

assign mul_out = (mul_en_out) ? mul_out_reg : 'd0;

// Input enable signal sampling
reg input_enable_sampled;
always @(posedge clk) begin
    if (!rst_n)
        input_enable_sampled <= 1'b0;
    else
        input_enable_sampled <= mul_en_in;
end

assign mul_en_out = (input_enable_sampled & ~input_enable_sampled);

endmodule