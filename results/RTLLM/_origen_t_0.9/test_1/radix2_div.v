module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire sign,
    input wire opn_valid,
    output reg res_valid,
    input wire res_ready,
    output wire [15:0] result
);

    reg [7:0] dividend_reg, divisor_reg;
    reg [7:0] NEG_DIVISOR;
    reg [15:0] SR;
    reg [3:0] cnt;
    reg start_cnt;
    wire carry_out;

    assign result = SR;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            SR <= 16'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
                NEG_DIVISOR <= sign ? -divisor : divisor;
                SR <= {8'd0, sign ? -dividend : dividend};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
            end

            if (start_cnt) begin
                if (cnt[3]) begin
                    cnt <= 4'd0;
                    start_cnt <= 1'b0;
                end else begin
                    cnt <= cnt + 1'b1;
                    if (SR[15:8] >= NEG_DIVISOR) begin
                        SR <= {SR[14:0], 1'b1};
                    end else begin
                        SR <= {SR[14:0], 1'b0};
                    end
                end
            end

            if (res_ready && res_valid) begin
                res_valid <= 1'b0;
            end else if (cnt == 4'd0 && !res_valid) begin
                res_valid <= 1'b1;
            end
        end
    end

endmodule