### Solution:
module multi_pipe_4bit#(
    parameter size = 4
)(
    input  clk,
    input  rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output [N-1:0] mul_out
);

    localparam N = 2 * size;

    reg [size-1:0] reg_a, reg_b;
    reg [N-1:0] reg_out;
    reg [N-1:0] reg_sum [size-1:0];

    wire [size-1:0] ext_mul_a, ext_mul_b;
    wire [N-1:0] partial_products [size-1:0];

    assign ext_mul_a = {size{1'b0}} | mul_a;
    assign ext_mul_b = {size{1'b0}} | mul_b;

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_mul
            assign partial_products[i] = ext_mul_a & (ext_mul_b[i] ? (ext_mul_b << i) : 'd0);
        end
    endgenerate

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                reg_sum[j] <= 'd0;
            end
            reg_out <= 'd0;
        end else begin
            reg_a <= mul_a;
            reg_b <= mul_b;
            reg_out <= 'd0;
            for (j = 0; j < size; j = j + 1) begin
                reg_sum[j] <= reg_sum[j-1] + partial_products[j];
                reg_out <= reg_sum[j-1] + partial_products[j];
            end
        end
    end

    assign mul_out = reg_out;

endmodule