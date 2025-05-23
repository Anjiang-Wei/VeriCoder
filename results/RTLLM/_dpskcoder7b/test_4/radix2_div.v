reg [15:0] shift_reg;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] neg_divisor;
    reg [7:0] cnt;
    reg start_cnt;
    reg carry_out;
    reg [15:0] remainder;
    reg [15:0] quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            shift_reg <= 16'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            neg_divisor <= 8'b0;
            cnt <= 8'b0;
            start_cnt <= 1'b0;
            carry_out <= 1'b0;
            remainder <= 16'b0;
            quotient <= 16'b0;
        end else if (opn_valid && !res_valid) begin
            abs_dividend <= (sign) ? -dividend : dividend;
            abs_divisor <= (sign) ? -divisor : divisor;
            shift_reg <= {1'b0, abs_dividend};
            neg_divisor <= ~abs_divisor + 1'b1;
            cnt <= 8'b1;
            start_cnt <= 1'b1;
        end else if (start_cnt && cnt != 8'b0) begin
            carry_out <= (shift_reg[15:8] >= neg_divisor) ? 1'b1 : 1'b0;
            if (carry_out) begin
                shift_reg <= {shift_reg[14:0], 1'b0} + neg_divisor;
            end else begin
                shift_reg <= {shift_reg[14:0], 1'b0};
            end
            cnt <= cnt + 1'b1;
        end else if (start_cnt && cnt == 8'b0) begin
            start_cnt <= 1'b0;
            res_valid <= 1'b1;
            if (shift_reg[15] == 1'b0) begin
                quotient <= {shift_reg[14:0], 1'b0};
                remainder <= {1'b0, abs_dividend} - {8'b0, quotient};
            end else begin
                quotient <= {shift_reg[14:0], 1'b1};
                remainder <= {1'b0, abs_dividend} - {8'b0, quotient} + abs_divisor;
            end
        end else if (res_valid && res_ready) begin
            res_valid <= 1'b0;
        end
    end

    assign result = {remainder, quotient};

endmodule