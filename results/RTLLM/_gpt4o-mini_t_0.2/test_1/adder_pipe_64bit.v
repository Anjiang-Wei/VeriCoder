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

    // Pipeline registers for intermediate results and enables
    reg [DATA_WIDTH-1:0] reg_adda, reg_addb;
    reg [DATA_WIDTH:0] sum_stage1, sum_stage2;

    // State control to manage output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_adda <= 0;
            reg_addb <= 0;
            sum_stage1 <= 0;
            sum_stage2 <= 0;
            result <= 0;
            o_en <= 0;
        end else if (i_en) begin
            // Stage 1: Capture inputs
            reg_adda <= adda;
            reg_addb <= addb;
            // Stage 2: Calculate sum
            sum_stage1 <= {1'b0, reg_adda} + {1'b0, reg_addb}; // 65-bit addition
            // Stage 3: Transfer to final output
            sum_stage2 <= sum_stage1; // Propagate through pipeline
            result <= sum_stage2; // Update the result
            o_en <= 1; // Signal result is valid
        end else begin
            o_en <= 0; // No valid result if enable is not set
        end
    end

endmodule