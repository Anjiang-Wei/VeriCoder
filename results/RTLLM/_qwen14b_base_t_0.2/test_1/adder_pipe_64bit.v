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
    
    // Internal signals
    reg [DATA_WIDTH:0] sum_reg [0:STG_WIDTH-1];
    reg [STG_WIDTH-1:0] en_reg;
    reg [STG_WIDTH-1:0] o_en_reg;

    // Pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= 0;
            end
            en_reg <= 0;
            o_en_reg <= 0;
            o_en <= 0;
        end else begin
            // Pipeline enable signal
            en_reg[0] <= i_en;
            for (int i = 0; i < STG_WIDTH-1; i = i + 1) begin
                en_reg[i+1] <= en_reg[i];
            end

            // Calculate sum in each stage
            sum_reg[0] <= adda + addb;
            for (int i = 0; i < STG_WIDTH-1; i = i + 1) begin
                sum_reg[i+1] <= sum_reg[i];
            end

            // Output enable signal
            o_en_reg[0] <= en_reg[STG_WIDTH-1];
            for (int i = 0; i < STG_WIDTH-1; i = i + 1) begin
                o_en_reg[i+1] <= o_en_reg[i];
            end
            o_en <= o_en_reg[STG_WIDTH-1];

            // Assign the final result
            result <= sum_reg[STG_WIDTH-1];
        end
    end

endmodule