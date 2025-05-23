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
    output reg [DATA_WIDTH+1:0] result, // +1 for carry out
    output reg o_en
);

// Pipeline registers
reg [DATA_WIDTH+1:0] stage_0_out;
reg [DATA_WIDTH+1:0] stage_1_out;
reg [DATA_WIDTH+1:0] stage_2_out;
reg [DATA_WIDTH+1:0] stage_3_out;

reg [STG_WIDTH-1:0] pipeline_stages_en;

always @(posedge clk) begin
    if (!rst_n) begin
        stage_0_out <= 0;
        stage_1_out <= 0;
        stage_2_out <= 0;
        stage_3_out <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Synchronize i_en with pipeline stages
        if (i_en && (!pipeline_stages_en)) begin
            pipeline_stages_en <= 1'b1;
        end

        // Pipeline stage 0
        if (pipeline_stages_en[0]) begin
            result <= adda + addb; // No carry for first stage
            stage_1_out <= {result[DATA_WIDTH:0], 1'b0}; // Carry out is not needed in this stage
            pipeline_stages_en <= pipeline_stages_en >> 1; // Move to next stage
        end

        // Pipeline stage 1
        if (pipeline_stages_en[1]) begin
            result <= {result, stage_1_out[DATA_WIDTH+1:1], stage_1_out[0]};
            stage_2_out <= {result[DATA_WIDTH:0], 1'b0};
            pipeline_stages_en <= pipeline_stages_en >> 1;
        end

        // Pipeline stage 2
        if (pipeline_stages_en[2]) begin
            result <= {result, stage_2_out[DATA_WIDTH+1:1], stage_2_out[0]};
            stage_3_out <= {result[DATA_WIDTH:0], 1'b0};
            pipeline_stages_en <= pipeline_stages_en >> 1;
        end

        // Pipeline stage 3
        if (pipeline_stages_en[3]) begin
            result <= {result, stage_3_out[DATA_WIDTH+1:1], stage_3_out[0]};
            o_en <= 1'b1; // Result is ready
            pipeline_stages_en <= pipeline_stages_en >> 1;
        end

        // Reset pipeline stages when i_en is deasserted
        if (!i_en) begin
            result <= 0;
            stage_0_out <= 0;
            stage_1_out <= 0;
            stage_2_out <= 0;
            stage_3_out <= 0;
            o_en <= 0;
            pipeline_stages_en <= 0;
        end
    end
end

assign result[DATA_WIDTH] = stage_3_out[DATA_WIDTH];

endmodule