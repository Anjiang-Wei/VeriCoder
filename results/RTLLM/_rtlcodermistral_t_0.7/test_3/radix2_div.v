// Sign and Absolute value
wire [7:0] abs_dividend;
assign abs_dividend = sign ? $signed(dividend) : dividend;

wire [7:0] abs_divisor;
assign abs_divisor = sign ? $signed(divisor) : divisor;

wire [7:0] neg_divisor;
assign neg_divisor = ~abs_divisor + 1;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] result_reg;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        result_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            dividend_reg <= abs_dividend;
            divisor_reg <= abs_divisor;
            cnt <= 1;
            start_cnt <= 1;
        end
        if (start_cnt) begin
            if (cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                result_reg <= {dividend_reg, neg_divisor[7:0]};
            end else begin
                cnt <= cnt + 1;
                result_reg <= {result_reg[14:0], abs_divisor[7]};
                if (neg_divisor[7] != result_reg[15]) begin
                    result_reg <= result_reg - neg_divisor;
                end
            end
        end
        if (res_ready) begin
            res_valid <= 1;
        end
    end
end

assign result = result_reg;

endmodule