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
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);
    
    // Internal signals
    reg [DATA_WIDTH:0] sum [STG_WIDTH-1:0];
    reg [STG_WIDTH-1:0] en_reg;

    // Pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_reg <= 0;
            o_en <= 0;
            for (int i = 0; i < STG_WIDTH; i = i + 1) begin
                sum[i] <= 0;
            end
        end else begin
            // Shift the enable signal through the pipeline stages
            en_reg <= {en_reg[STG_WIDTH-2:0], i_en};
            // Calculate the sum for each stage
            for (int i = 0; i < STG_WIDTH; i = i + 1) begin
                if (i == 0) begin
                    sum[i] <= adda + addb;
                end else begin
                    sum[i] <= sum[i-1];
                end
            end
            // Output enable signal is valid after the last stage
            o_en <= en_reg[STG_WIDTH-1];
        end
    end

    // Assign the result to the output port
    assign result = sum[STG_WIDTH-1];

endmodule