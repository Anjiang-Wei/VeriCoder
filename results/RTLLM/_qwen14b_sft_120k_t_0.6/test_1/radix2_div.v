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

    reg [15:0] SR;
    reg [7:0] NEG_DIVISOR;
    reg [2:0] cnt;
    reg start_cnt;
    reg [7:0] dividend_abs, divisor_abs;
    reg [7:0] quotient, remainder;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            quotient <= 8'b0;
            remainder <= 8'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                dividend_abs <= sign ? -dividend : dividend;
                divisor_abs <= sign ? -divisor : divisor;
                SR <= {{1{dividend_abs[7]}}, dividend_abs} << 1;
                NEG_DIVISOR <= {divisor_abs[7], ~divisor_abs};
                cnt <= 3'b0;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 3'b100) begin
                    cnt <= 3'b0;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                    result <= {remainder, quotient};
                end else begin
                    cnt <= cnt + 1;
                    if (SR[15:8] >= NEG_DIVISOR) begin
                        SR <= {SR[14:0], 1'b1};
                    end else begin
                        SR <= {SR[14:0], 1'b0};
                        quotient[7 - cnt[2:0]] <= 1'b1;
                    end
                end
            end else if (res_ready) begin
                res_valid <= 1'b0;
                remainder <= SR[15:8];
            end
        end
    end

endmodule