// Operation Start
reg [8:0] SR;
reg [7:0] abs_dividend;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if(rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end
    else begin
        if(opn_valid && !res_valid) begin
            abs_dividend <= sign ? $signed(dividend) : dividend;
            NEG_DIVISOR <= sign ? -$signed(divisor) : -divisor;
            SR <= {1'b0, abs_dividend} << 1;
            cnt <= 1;
            start_cnt <= 1;
        end
        else begin
            start_cnt <= 0;
            if(cnt == 8) begin
                cnt <= 0;
                res_valid <= 1;
            end
            else begin
                cnt <= cnt + 1;
                if(SR[8] == 0) begin
                    SR <= {1'b0, SR[7:0]} - {NEG_DIVISOR[7], NEG_DIVISOR};
                end
                else begin
                    SR <= {1'b0, SR[7:0]} + {NEG_DIVISOR[7], NEG_DIVISOR};
                end
            end
        end
    end
end

assign result = {SR[15:8], SR[7:0]};

endmodule