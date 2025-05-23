module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16  // Number of stages
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

    // Internal registers for pipelining
    reg [DATA_WIDTH-1:0] reg_a [0:STG_WIDTH-1];
    reg [DATA_WIDTH-1:0] reg_b [0:STG_WIDTH-1];
    reg [DATA_WIDTH:0] reg_sum [0:STG_WIDTH-1];
    reg [STG_WIDTH-1:0] en_pipeline;

    integer i;

    // Sequential logic for pipelining
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers and output
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                reg_a[i] <= 0;
                reg_b[i] <= 0;
                reg_sum[i] <= 0;
            end
            o_en <= 0;
            en_pipeline <= 0;
            result <= 0;
        end else begin
            // Shift pipeline only if i_en is high
            if (i_en) begin
                // Load the initial values into the first stage
                reg_a[0] <= adda;
                reg_b[0] <= addb;
                en_pipeline[0] <= 1;

                // Ripple carry addition for the first stage
                reg_sum[0] <= {1'b0, reg_a[0]} + {1'b0, reg_b[0]};

                // Shift the pipeline
                for (i = 1; i < STG_WIDTH; i = i + 1) begin
                    reg_a[i] <= reg_a[i-1];
                    reg_b[i] <= reg_b[i-1];
                    reg_sum[i] <= reg_sum[i-1];
                    en_pipeline[i] <= en_pipeline[i-1];
                end

                // Update output result and enable signal
                result <= reg_sum[STG_WIDTH-1];
                o_en <= en_pipeline[STG_WIDTH-1];
            end else begin
                // If not enabled, the output enable should not be set
                o_en <= 0;
            end
        end
    end

endmodule