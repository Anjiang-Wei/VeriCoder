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

reg [DATA_WIDTH:0] [STG_WIDTH-1:0] sum;
reg [STG_WIDTH-1:0] en;
reg [DATA_WIDTH:0] carry;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
        en <= 0;
        carry <= 0;
        o_en <= 0;
    end
    else begin
        if (i_en) begin
            sum[0] <= adda[0] ^ addb[0] ^ carry[0];
            carry[0] <= (adda[0] & addb[0]) | (adda[0] & carry[0]) | (addb[0] & carry[0]);
            en[0] <= 1;
        end
        else begin
            en[0] <= 0;
        end

        for (integer i = 1; i < STG_WIDTH; i = i+1) begin
            sum[i] <= adda[i] ^ addb[i] ^ carry[i-1];
            carry[i] <= (adda[i] & addb[i]) | (adda[i] & carry[i-1]) | (addb[i] & carry[i-1]);
            en[i] <= en[i-1];
        end

        sum[STG_WIDTH] <= adda[STG_WIDTH] ^ addb[STG_WIDTH] ^ carry[STG_WIDTH-1];
        carry[STG_WIDTH] <= (adda[STG_WIDTH] & addb[STG_WIDTH]) | (adda[STG_WIDTH] & carry[STG_WIDTH-1]) | (addb[STG_WIDTH] & carry[STG_WIDTH-1]);
        o_en <= en[STG_WIDTH-1];
        result <= {carry[STG_WIDTH], sum[STG_WIDTH-1:0]};
    end
end

endmodule