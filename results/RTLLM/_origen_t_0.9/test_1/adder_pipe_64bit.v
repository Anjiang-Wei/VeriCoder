### Solution:
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

    reg [DATA_WIDTH-1:0] adda_reg [STG_WIDTH:0];
    reg [DATA_WIDTH-1:0] addb_reg [STG_WIDTH:0];
    reg [DATA_WIDTH:0] sum_reg [STG_WIDTH:0];
    reg [STG_WIDTH:0] en_reg;

    wire [DATA_WIDTH:0] sum;
    wire carry;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STG_WIDTH; i = i + 1) begin
                adda_reg[i] <= 0;
                addb_reg[i] <= 0;
                sum_reg[i] <= 0;
            end
            en_reg <= 0;
            o_en <= 0;
        end else begin
            adda_reg[0] <= adda;
            addb_reg[0] <= addb;
            sum_reg[0] <= {1'b0, adda} + {1'b0, addb};
            en_reg[0] <= i_en;

            for (i = 1; i <= STG_WIDTH; i = i + 1) begin
                adda_reg[i] <= adda_reg[i-1];
                addb_reg[i] <= addb_reg[i-1];
                sum_reg[i] <= sum_reg[i-1] + adda_reg[i-1] + addb_reg[i-1];
                en_reg[i] <= en_reg[i-1];
            end

            o_en <= en_reg[STG_WIDTH];
        end
    end

    assign result = sum_reg[STG_WIDTH];

endmodule