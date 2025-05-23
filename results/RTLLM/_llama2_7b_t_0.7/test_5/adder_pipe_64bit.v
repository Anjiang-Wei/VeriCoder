module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);

// Define registers for pipeline stages
localparam Stage1 = 2**(STG_WIDTH-1); // Stage 1 register size
localparam Stage2 = Stage1 * 2; // Stage 2 register size
localparam Stage3 = Stage2 * 2; // Stage 3 register size
localparam Stage4 = Stage3 * 2; // Stage 4 register size
localparam Stage5 = Stage4 * 2; // Stage 5 register size

// Define pipeline stages and input enable signals
wire [STG_WIDTH-1:0] stage1_result, stage2_result, stage3_result, stage4_result, stage5_result;
wire [DATA_WIDTH-1:0] sum;

assign stage1_result = i_en & adda;
assign stage2_result = stage1_result | carry;
assign stage3_result = stage2_result | carry;
assign stage4_result = stage3_result | carry;
assign stage5_result = stage4_result | carry;
assign sum = stage5_result;

// Output enable signal
wire o_en;
assign o_en = i_en & (sum != 0);

// Add result to output port
assign result = sum;