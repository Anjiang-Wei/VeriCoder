module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 4
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
    reg [DATA_WIDTH:0] sum [0:STG_WIDTH-1];
    reg [STG_WIDTH-1:0] en_pipe;

    // Pipeline stage logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 0;
            o_en <= 0;
            for (integer i = 0; i < STG_WIDTH; i = i + 1) begin
                sum[i] <= 0;
            end
        end else begin
            // Shift the pipeline enable signal
            en_pipe <= {en_pipe[STG_WIDTH-2:0], i_en};
            // Calculate the sum for each stage
            for (integer i = 0; i < STG_WIDTH; i = i + 1) begin
                if (i == 0) begin
                    sum[i] <= adda + addb;
                end else begin
                    sum[i] <= sum[i-1];
                end
            end
            // Output enable signal
            o_en <= en_pipe[STG_WIDTH-1];
        end
    end

    // Assign the final result
    assign result = sum[STG_WIDTH-1];

endmodule