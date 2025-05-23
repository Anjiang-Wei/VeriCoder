module multi_pipe_4bit#(
    parameter size = 4
)(
    input                      clk      ,   
    input                      rst_n    ,
    input  [size-1:0]         mul_a    ,
    input  [size-1:0]         mul_b    ,
    output reg [2*size-1:0]   mul_out      
);

// Parameters
parameter N = 2 * size;

// Intermediate storage for partial products
reg [N-1:0] partial_products [0:size-1];
reg [N-1:0] sum; // Intermediate sum of partial products

// Generate the partial products
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : gen_partial_products
        always @(*) begin
            if (mul_b[i] == 1'b1)
                partial_products[i] = {mul_a, {i{1'b0}}}; // Left shift multiplicand
            else
                partial_products[i] = {N{1'b0}}; // Zero if bit is 0
        end
    end
endgenerate

// Register for intermediate sum
reg [N-1:0] p_sum [0:size-1];

// Accumulate partial products on clock edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out      <= 0;
        sum          <= 0;
        p_sum[0]     <= 0;
        p_sum[1]     <= 0;
        p_sum[2]     <= 0;
        p_sum[3]     <= 0;
    end else begin
        // Perform the addition of partial products
        sum <= 0;
        for (integer j = 0; j < size; j = j + 1) begin
            p_sum[j] <= partial_products[j];
            sum <= sum + p_sum[j]; // Accumulate sum
        end
        mul_out <= sum; // Update final product output
    end
end

endmodule