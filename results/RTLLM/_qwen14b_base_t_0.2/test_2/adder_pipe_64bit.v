module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 4  // Number of pipeline stages
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
    
    // Internal signals for pipeline stages
    reg [DATA_WIDTH:0] stage0, stage1, stage2, stage3;
    reg [DATA_WIDTH:0] sum;
    reg [STG_WIDTH-1:0] pipeline_enable;

    // Pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0 <= 0;
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            pipeline_enable <= 0;
            o_en <= 0;
        end else begin
            // Pipeline enable signal
            if (i_en) begin
                pipeline_enable <= pipeline_enable + 1;
            end else begin
                pipeline_enable <= 0;
            end

            // Stage 0: Initial addition
            stage0 <= {adda[DATA_WIDTH-1], adda} + {addb[DATA_WIDTH-1], addb};

            // Stage 1: Pipeline register
            stage1 <= stage0;

            // Stage 2: Pipeline register
            stage2 <= stage1;

            // Stage 3: Pipeline register and output
            stage3 <= stage2;
            sum <= stage3;
            o_en <= (pipeline_enable == STG_WIDTH);
        end
    end

    // Assign the result
    assign result = sum;

endmodule