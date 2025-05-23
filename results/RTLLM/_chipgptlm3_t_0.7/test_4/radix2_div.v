verilog
reg signed [7:0] dividend_abs;
reg signed [7:0] divisor_abs;
reg signed [7:0] shift_reg;
reg signed [7:0] neg_divisor;
reg signed [7:0] remainder;
reg signed [7:0] quotient;
reg signed [7:0] temp;

reg signed [7:0] sr;

reg [3:0] cnt;
reg [3:0] start_cnt;

reg carry_out;

reg signed [7:0] temp1;

wire [7:0] sub_res;
wire [7:0] sub_res_neg;
wire [7:0] sub_res_pos;
wire [7:0] sub_res_neg_pos;

assign sub_res = dividend_abs - divisor_abs;
assign sub_res_neg = -sub_res;
assign sub_res_pos = dividend_abs - neg_divisor;
assign sub_res_neg_pos = -sub_res_pos;

always @(posedge clk) begin
    if(rst) begin
        dividend_abs = 8'b0;
        divisor_abs = 8'b0;
        shift_reg = 8'b0;
        neg_divisor = 8'b0;
        remainder = 8'b0;
        quotient = 8'b0;
        temp = 8'b0;
        sr = 8'b0;
        cnt = 4'b0;
        start_cnt = 4'b0;
        carry_out = 1'b0;
        res_valid = 1'b0;
    end else begin
        if(opn_valid & ~res_valid & ~res_ready) begin
            dividend_abs = sign? -dividend : dividend;
            divisor_abs = sign? -divisor : divisor;
            neg_divisor = -divisor_abs;
            shift_reg = {1'b0, dividend_abs};
            cnt = 4'b0;
            start_cnt = 4'b1;
        end else if(start_cnt) begin
            if(cnt == 4'b1000) begin
                res_valid = 1'b1;
                if(sign) begin
                    remainder = sign? -remainder : remainder;
                    quotient = sign? -quotient : quotient;
                end
                temp = sr >> 1;
                remainder = remainder - divisor_abs;
                quotient = quotient + 1;
                if(remainder < 0) begin
                    remainder = remainder + divisor_abs;
                    quotient = quotient - 1;
                end
                start_cnt = 4'b0;
                cnt = 4'b0;
                shift_reg = {1'b0, remainder};
            end else begin
                temp1 = sub_res_neg;
                if(carry_out) begin
                    temp1 = sub_res_neg_pos;
                end
                shift_reg = {shift_reg[7:0], 1'b0};
                carry_out = temp1[7];
                if(carry_out) begin
                    remainder = remainder - divisor_abs;
                end else begin
                    remainder = remainder + divisor_abs;
                end
                quotient = quotient + 1;
                if(remainder < 0) begin
                    remainder = remainder + divisor_abs;
                    quotient = quotient - 1;
                end
                cnt = cnt + 1;
            end
        end
    end
end

assign result = {remainder, quotient};

endmodule
```