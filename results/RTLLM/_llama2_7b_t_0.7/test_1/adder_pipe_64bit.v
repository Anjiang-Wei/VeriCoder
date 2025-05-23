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

// Registers for pipeline stages
localparam PIPELINE_STAGES = 4;
reg [PIPELINE_STAGES*STG_WIDTH-1:0] stage_inputs;
reg [PIPELINE_STAGES*STG_WIDTH-1:0] stage_carries;
reg [DATA_WIDTH-1:0] result_stage0;
reg [DATA_WIDTH-1:0] result_stage1;
reg [DATA_WIDTH-1:0] result_stage2;
reg [DATA_WIDTH-1:0] result_stage3;

// Pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset pipeline stage outputs
        result_stage0 <= 0;
        result_stage1 <= 0;
        result_stage2 <= 0;
        result_stage3 <= 0;
    end else begin
        // Calculate next pipeline stage output
        case (PIPELINE_STAGES) matches {
            // Stage 0: Add A and B, carry result to next stage
            0: result_stage0 = adda + addb + (stage_carries[0] << STG_WIDTH);
            // Stage 1: Add carry from previous stage to current stage
            1: result_stage1 = result_stage0 + stage_carries[1];
            // Stage 2: Add carry from previous stage to current stage
            2: result_stage2 = result_stage1 + stage_carries[2];
            // Stage 3: Add carry from previous stage to current stage and output result
            3: result_stage3 = result_stage2 + stage_carries[3];
        }
        // Update pipeline stage outputs
        stage_inputs <= adda;
        stage_carries <= stage_carries + (result_stage0 << STG_WIDTH);
    end
end

// Output enable synchronization
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset output enable signal
        o_en <= 0;
    end else begin
        // Update output enable signal based on pipeline stages
        o_en <= (result_stage3[0] == 1'b1);
    end
end

// Connect input and output signals
assign adda = input [DATA_WIDTH-1:0];
assign addb = input [DATA_WIDTH-1:0];
assign result = result_stage3;
assign o_en = o_en;