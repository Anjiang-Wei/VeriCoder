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
    // Pipeline registers for synchronization
    reg [STG_WIDTH-1:0] i_en_pipe [0:DATA_WIDTH/STG_WIDTH];
    reg [DATA_WIDTH:0] sum_pipe [0:DATA_WIDTH/STG_WIDTH];

    // Pipeline stages
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH/STG_WIDTH; i = i + 1) begin : gen_pipe
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    i_en_pipe[i] <= 0;
                    sum_pipe[i] <= 0;
                end else begin
                    i_en_pipe[i] <= i_en;
                    if (i == 0) begin
                        sum_pipe[i] <= adda[STG_WIDTH*i +: STG_WIDTH] + addb[STG_WIDTH*i +: STG_WIDTH];
                    end else begin
                        sum_pipe[i] <= sum_pipe[i-1][STG_WIDTH:i*STG_WIDTH] + adda[STG_WIDTH*i +: STG_WIDTH] + addb[STG_WIDTH*i +: STG_WIDTH];
                    end
                end
            end
        end
    endgenerate

    // Output enable and result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 0;
            result <= 0;
        end else if (i_en) begin
            o_en <= i_en_pipe[DATA_WIDTH/STG_WIDTH-1];
            result <= sum_pipe[DATA_WIDTH/STG_WIDTH-1];
        end
    end

endmodule