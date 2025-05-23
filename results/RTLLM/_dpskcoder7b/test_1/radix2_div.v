reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] remainder;
    reg [7:0] quotient;
    reg [7:0] sr;
    reg [7:0] neg_divisor;
    reg [2:0] cnt;
    reg start_cnt;
    reg carry_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            remainder <= 8'b0;
            quotient <= 8'b0;
            sr <= 8'b0;
            neg_divisor <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else if (opn_valid && !res_valid) begin
            abs_dividend <= (dividend[7] && sign) ? -dividend : dividend;
            abs_divisor <= (divisor[7] && sign) ? -divisor : divisor;
            sr <= {1'b1, abs_dividend[7:1]};
            neg_divisor <= -abs_divisor;
            cnt <= 3'b01;
            start_cnt <= 1'b1;
        end else if (start_cnt && cnt < 8'd8) begin
            carry_out <= |(sr + neg_divisor);
            sr <= {1'b1, sr[7:1]};
            cnt <= cnt + 3'b01;
            if (cnt == 8'd7) begin
                start_cnt <= 1'b0;
                remainder <= sr[7:0];
                quotient <= sr[15:8];
            end
        end

        if (!res_valid && start_cnt == 1'b0 && cnt == 8'd8 && res_ready) begin
            res_valid <= 1'b1;
        end else if (res_valid && res_ready) begin
            res_valid <= 1'b0;
        end
    end

    assign result = {quotient, remainder};

endmodule