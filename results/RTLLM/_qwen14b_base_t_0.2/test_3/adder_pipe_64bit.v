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
    
    // Internal signals
    reg [DATA_WIDTH:0] sum_reg [0:STG_WIDTH-1];
    reg [STG_WIDTH-1:0] en_reg;

    // Pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= 0;
            end
            en_reg <= 0;
            o_en <= 0;
        end else begin
            // Shift the enable signal through the pipeline stages
            en_reg <= {en_reg[STG_WIDTH-2:0], i_en};
            // Calculate the sum in each stage
            for (int i = 0; i < STG_WIDTH; i = i + 1) begin
                if (i == 0) begin
                    sum_reg[i] <= adda + addb;
                end else begin
                    sum_reg[i] <= sum_reg[i-1];
                end
            end
            // Output enable signal is set when the last stage is enabled
            o_en <= en_reg[STG_WIDTH-1];
        end
    end

    // Assign the result to the output port
    assign result = sum_reg[STG_WIDTH-1];

endmodule