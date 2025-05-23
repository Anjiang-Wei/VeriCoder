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
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

    // Pipeline registers
    reg [DATA_WIDTH-1:0] pipe_a[0:3];  // Pipelines for input operands A
    reg [DATA_WIDTH-1:0] pipe_b[0:3];  // Pipelines for input operands B
    reg [DATA_WIDTH:0] pipe_sum[0:3];   // Pipelines for computed sums

    // Stage processing enable
    reg [1:0] stage;  // 2-bit stage register to track the current stage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            pipe_a[0] <= 0;
            pipe_b[0] <= 0;
            pipe_sum[0] <= 0;
            pipe_sum[1] <= 0;
            pipe_sum[2] <= 0;
            pipe_sum[3] <= 0;
            stage <= 0;
            o_en <= 0;
            result <= 0;
        end else if (i_en) begin
            // Stage 0: Register the inputs
            pipe_a[0] <= adda;
            pipe_b[0] <= addb;
            // Stage 1
            pipe_sum[0] <= {1'b0, pipe_a[0]} + {1'b0, pipe_b[0]};
            // Stage 2
            pipe_a[1] <= pipe_a[0];
            pipe_b[1] <= pipe_b[0];
            pipe_sum[1] <= pipe_sum[0];
            // Stage 3
            pipe_a[2] <= pipe_a[1];
            pipe_b[2] <= pipe_b[1];
            pipe_sum[2] <= pipe_sum[1];
            // Final stage
            pipe_a[3] <= pipe_a[2];
            pipe_b[3] <= pipe_b[2];
            pipe_sum[3] <= pipe_sum[2];

            // Output the final result
            o_en <= 1;
            result <= pipe_sum[3];
        end else begin
            o_en <= 0; // Disable output if not enabled
        end
    end

endmodule