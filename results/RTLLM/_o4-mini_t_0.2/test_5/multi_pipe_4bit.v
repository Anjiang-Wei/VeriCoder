module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input  [size-1:0]         mul_a,
    input  [size-1:0]         mul_b,
    output reg [2*size-1:0]   mul_out
);

parameter N = 2 * size;

// -----------------------------------------------------------------------------
// 1) Extend the multiplicand to 2*size bits by prefixing size zeros
// -----------------------------------------------------------------------------
wire [N-1:0] a_ext;
assign a_ext = { {size{1'b0}}, mul_a };

// -----------------------------------------------------------------------------
// 2) Generate partial products pp[i] = (mul_b[i] ? a_ext << i : 0)
// -----------------------------------------------------------------------------
wire [N-1:0] pp [0:size-1];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : GEN_PP
        assign pp[i] = mul_b[i] 
                       ? (a_ext << i) 
                       : {N{1'b0}};
    end
endgenerate

// -----------------------------------------------------------------------------
// 3) Stage‑1 pipeline registers: sum the first half & second half of partials
// -----------------------------------------------------------------------------
reg [N-1:0] sum_stage1_a;
reg [N-1:0] sum_stage1_b;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1_a <= {N{1'b0}};
        sum_stage1_b <= {N{1'b0}};
    end else begin
        // for size=4 we split: pp[0]+pp[1] and pp[2]+pp[3]
        sum_stage1_a <= pp[0] + pp[1];
        sum_stage1_b <= pp[2] + pp[3];
    end
end

// -----------------------------------------------------------------------------
// 4) Stage‑2 pipeline register: final product
// -----------------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= {N{1'b0}};
    else
        mul_out <= sum_stage1_a + sum_stage1_b;
end

endmodule