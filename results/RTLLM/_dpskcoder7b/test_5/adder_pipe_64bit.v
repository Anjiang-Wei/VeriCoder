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

    reg [DATA_WIDTH-1:0] stage1;
    reg [DATA_WIDTH-1:0] stage2;
    reg [DATA_WIDTH-1:0] stage3;
    reg [DATA_WIDTH-1:0] stage4;
    reg [DATA_WIDTH-1:0] stage5;
    reg [DATA_WIDTH-1:0] stage6;
    reg [DATA_WIDTH-1:0] stage7;
    reg [DATA_WIDTH-1:0] stage8;

    reg [DATA_WIDTH:0] sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
            stage8 <= 0;
            sum <= 0;
            o_en <= 0;
        end else begin
            if (i_en) begin
                stage1 <= adda[DATA_WIDTH/2-1:0] + addb[DATA_WIDTH/2-1:0];
                stage2 <= adda[DATA_WIDTH-1:DATA_WIDTH/2] + addb[DATA_WIDTH-1:DATA_WIDTH/2] + {DATA_WIDTH/2{stage1[DATA_WIDTH/2]}};
                stage3 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*2] + addb[DATA_WIDTH-1:DATA_WIDTH/2*2] + {DATA_WIDTH/2{stage2[DATA_WIDTH/2]}};
                stage4 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*3] + addb[DATA_WIDTH-1:DATA_WIDTH/2*3] + {DATA_WIDTH/2{stage3[DATA_WIDTH/2]}};
                stage5 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*4] + addb[DATA_WIDTH-1:DATA_WIDTH/2*4] + {DATA_WIDTH/2{stage4[DATA_WIDTH/2]}};
                stage6 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*5] + addb[DATA_WIDTH-1:DATA_WIDTH/2*5] + {DATA_WIDTH/2{stage5[DATA_WIDTH/2]}};
                stage7 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*6] + addb[DATA_WIDTH-1:DATA_WIDTH/2*6] + {DATA_WIDTH/2{stage6[DATA_WIDTH/2]}};
                stage8 <= adda[DATA_WIDTH-1:DATA_WIDTH/2*7] + addb[DATA_WIDTH-1:DATA_WIDTH/2*7] + {DATA_WIDTH/2{stage7[DATA_WIDTH/2]}};
                sum <= {stage8, {DATA_WIDTH/2{stage7[DATA_WIDTH/2]}}};
                o_en <= 1;
            end else begin
                stage1 <= 0;
                stage2 <= 0;
                stage3 <= 0;
                stage4 <= 0;
                stage5 <= 0;
                stage6 <= 0;
                stage7 <= 0;
                stage8 <= 0;
                sum <= 0;
                o_en <= 0;
            end
        end
    end

    assign result = sum;

endmodule