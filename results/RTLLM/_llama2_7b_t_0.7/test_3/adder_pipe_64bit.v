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

// Stage 1: Add and carry propagation
wire [63:0] stage1_result = {adda, addb};
wire [63:0] stage1_carry = adda + addb;
wire [63:0] stage1_sum = stage1_result + stage1_carry;

// Stage 2: Add and carry propagation
wire [63:0] stage2_result = {stage1_sum, carry};
wire [63:0] stage2_sum = stage2_result + addb;
wire [63:0] stage2_carry = stage2_sum + carry;

// Stage 3: Add and carry propagation
wire [63:0] stage3_result = {stage2_sum, carry};
wire [63:0] stage3_sum = stage3_result + adda;
wire [63:0] stage3_carry = stage3_sum + carry;

// Output enable synchronization
localparam OUTPUT_ENABLE_STAGES = 3; // Number of pipeline stages
wire [OUTPUT_ENABLE_STages-1:0] output_enable = {1'b0, o_en};

assign result = stage3_result[DATA_WIDTH-1:0];
assign o_en = output_enable[OUTPUT_ENABLE_STAGES-1:0];

// Clock and reset signals
input clk;
input rst_n;

endmodule