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

    reg [DATA_WIDTH-1:0] stg_a [STG_WIDTH:1];
    reg [DATA_WIDTH-1:0] stg_b [STG_WIDTH:1];
    reg [DATA_WIDTH-1:0] stg_sum [STG_WIDTH:1];
    reg [DATA_WIDTH:0] stg_result [STG_WIDTH:1];

    genvar i;
    generate
        for(i=1; i<=STG_WIDTH; i=i+1)
        begin: pipeline_stage
            if (i==1) begin
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        stg_a[i] <= '0;
                        stg_b[i] <= '0;
                        stg_sum[i] <= '0;
                        o_en <= 1'b0;
                    end else if (i_en) begin
                        stg_a[i] <= adda;
                        stg_b[i] <= addb;
                        stg_sum[i] <= stg_a[i] + stg_b[i];
                        o_en <= 1'b0;
                    end
                end
            end else begin
                always @(posedge clk or negedge rst_n) begin
                    if (!rst_n) begin
                        stg_sum[i] <= '0;
                        stg_result[i] <= '0;
                        o_en <= 1'b0;
                    end else if (i_en) begin
                        stg_sum[i] <= stg_sum[i-1] + stg_b[i];
                        stg_result[i] <= {1'b0, stg_sum[i]};
                        o_en <= 1'b0;
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= '0;
            o_en <= 1'b0;
        end else if (i_en) begin
            result <= stg_result[STG_WIDTH];
            o_en <= 1'b1;
        end
    end

endmodule