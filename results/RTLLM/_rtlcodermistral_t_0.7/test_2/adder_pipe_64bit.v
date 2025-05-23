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

reg [DATA_WIDTH-1:0] sum_reg [0:STG_WIDTH-1];
reg [STG_WIDTH-1:0] carry_reg [0:STG_WIDTH-1];

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 0;
        for (i = 0; i < STG_WIDTH; i = i + 1) begin
            sum_reg[i] <= 0;
            carry_reg[i] <= 0;
        end
    end
    else begin
        if (i_en) begin
            sum_reg[0] <= adda + addb;
            carry_reg[0] <= (adda[DATA_WIDTH-1] & addb[DATA_WIDTH-1]);
            for (i = 1; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= sum_reg[i-1] + carry_reg[i-1];
                carry_reg[i] <= (sum_reg[i-1][DATA_WIDTH-1] & carry_reg[i-1][DATA_WIDTH-1]);
            end
            sum_reg[STG_WIDTH] <= sum_reg[STG_WIDTH-1] + carry_reg[STG_WIDTH-1];
            carry_reg[STG_WIDTH] <= (sum_reg[STG_WIDTH-1][DATA_WIDTH-1] & carry_reg[STG_WIDTH-1][DATA_WIDTH-1]);
        end
        o_en <= 1;
        result <= {carry_reg[STG_WIDTH], sum_reg[STG_WIDTH]};
    end
end

endmodule