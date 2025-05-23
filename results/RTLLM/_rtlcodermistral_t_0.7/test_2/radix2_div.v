//Internal Signals
reg [7:0] abs_dividend;
reg [7:0] neg_divisor;
reg [7:0] remainder;
reg [7:0] quotient;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] SR;
reg [15:0] result_tmp;

always @(*) begin
    if(sign) begin
        abs_dividend = $signed(dividend) < 0 ? -dividend : dividend;
        neg_divisor = $signed(divisor) < 0 ? -divisor : divisor;
    end else begin
        abs_dividend = dividend;
        neg_divisor = 8'b0;
    end
end

always @(posedge clk) begin
    if(rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        SR <= 0;
        result_tmp <= 0;
    end else begin
        if(opn_valid && !res_valid) begin
            cnt <= 1;
            start_cnt <= 1;
            SR <= {abs_dividend[7], abs_dividend};
            result_tmp <= {remainder, quotient};
        end else if(start_cnt) begin
            cnt <= cnt + 1;
            if(cnt == 8) begin
                cnt <= 0;
                start_cnt <= 0;
                SR <= {remainder, quotient};
            end else begin
                SR <= {remainder, quotient};
                remainder <= SR[15] ? SR[15:0] - neg_divisor : SR[15:0] + neg_divisor;
            end
        end

        if(res_ready && res_valid) begin
            res_valid <= 0;
        end else if(!res_valid && cnt == 0) begin
            res_valid <= 1;
        end
    end
end

assign result = result_tmp;

endmodule