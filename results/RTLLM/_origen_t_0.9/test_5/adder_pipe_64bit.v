### Code:
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

    reg [DATA_WIDTH-1:0] a_reg [STG_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] b_reg [STG_WIDTH-1:0];
    reg [DATA_WIDTH:0] sum_reg [STG_WIDTH-1:0];
    reg [STG_WIDTH-1:0] i_en_reg;
    reg [STG_WIDTH-1:0] o_en_reg;

    wire [DATA_WIDTH:0] sum_wire [STG_WIDTH:0];
    wire [STG_WIDTH:0] i_en_wire;
    wire [STG_WIDTH:0] o_en_wire;

    assign i_en_wire[0] = i_en;
    assign o_en_wire[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < STG_WIDTH; i = i + 1) begin : pipe_stages
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    a_reg[i] <= {DATA_WIDTH{1'b0}};
                    b_reg[i] <= {DATA_WIDTH{1'b0}};
                    sum_reg[i] <= {(DATA_WIDTH+1){1'b0}};
                    i_en_reg[i] <= 1'b0;
                    o_en_reg[i] <= 1'b0;
                end else begin
                    a_reg[i] <= a_reg[i];
                    b_reg[i] <= b_reg[i];
                    sum_reg[i] <= sum_reg[i];
                    i_en_reg[i] <= i_en_wire[i];
                    o_en_reg[i] <= o_en_wire[i];

                    if (i_en_wire[i]) begin
                        a_reg[i] <= adda;
                        b_reg[i] <= addb;
                        sum_reg[i] <= a_reg[i] + b_reg[i];
                    end

                    if (o_en_wire[i]) begin
                        o_en_reg[i] <= 1'b1;
                    end else begin
                        o_en_reg[i] <= o_en_reg[i-1];
                    end
                end
            end

            assign sum_wire[i] = sum_reg[i];
            assign i_en_wire[i+1] = i_en_reg[i];
            assign o_en_wire[i+1] = o_en_reg[i];
        end
    endgenerate

    assign sum_wire[STG_WIDTH] = sum_reg[STG_WIDTH-1];
    assign result = sum_wire[STG_WIDTH];
    assign o_en = o_en_reg[STG_WIDTH-1];

endmodule