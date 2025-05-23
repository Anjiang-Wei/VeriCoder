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

    // Intermediate registers for pipelining
    reg [DATA_WIDTH-1:0] stage_a [0:STG_WIDTH-1];
    reg [DATA_WIDTH-1:0] stage_b [0:STG_WIDTH-1];
    reg [DATA_WIDTH:0] stage_sum [0:STG_WIDTH-1];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline stages and output enable signal
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                stage_a[i] <= 0;
                stage_b[i] <= 0;
                stage_sum[i] <= 0;
            end
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift pipeline registers
            for (i = STG_WIDTH-1; i > 0; i = i - 1) begin
                stage_a[i] <= stage_a[i-1];
                stage_b[i] <= stage_b[i-1];
                stage_sum[i] <= stage_sum[i-1];
            end
            
            // Load new data into the pipeline if enabled
            if (i_en) begin
                stage_a[0] <= adda;
                stage_b[0] <= addb;
                stage_sum[0] <= {1'b0, adda} + {1'b0, addb}; // Compute sum
            end
            
            // Assign the output from the last pipeline stage
            result <= stage_sum[STG_WIDTH-1];
            o_en <= (i_en || o_en) && (stage_sum[STG_WIDTH-1] !== 0); // Control output enable
        end
    end
endmodule