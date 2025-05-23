// The following signals are used in the division process:
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg [7:0] neg_divisor;
reg [7:0] cnt;
reg start_cnt;
reg [15:0] result;
reg [7:0] shift_reg;

// The following signals are used in the result validity management:
reg [1:0] cnt_rst;
reg [1:0] res_valid_rst;

```
// Calculate the absolute value of dividend and divisor:
always @(*) begin
    if (sign == 1) begin
        dividend_abs = $signed(dividend);
        divisor_abs = $signed(divisor);
    end else begin
        dividend_abs = dividend;
        divisor_abs = divisor;
    end
end

// Calculate the negated absolute value of divisor:
always @(*) begin
    if (divisor_abs[7] == 1) begin
        neg_divisor = ~divisor_abs + 1;
    end else begin
        neg_divisor = divisor_abs;
    end
end

// Initialize the shift register with the absolute value of dividend shifted left by one bit:
always @(posedge clk) begin
    if (rst == 1) begin
        shift_reg <= 8'b0;
    end else if (opn_valid == 1 && res_valid == 0) begin
        shift_reg <= {dividend_abs, 1'b0};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt == 1 && cnt == 8) begin
        cnt <= 0;
        start_cnt <= 0;
    end else if (start_cnt == 1) begin
        shift_reg <= shift_reg - neg_divisor;
        cnt <= cnt + 1;
    end
end

// Manage the result validity:
always @(posedge clk) begin
    if (rst == 1) begin
        res_valid <= 0;
        cnt_rst <= 2'b11;
        res_valid_rst <= 2'b11;
    end else if (res_ready == 1 && cnt == 8) begin
        res_valid <= 1;
        cnt_rst <= 2'b00;
        res_valid_rst <= 2'b00;
    end else if (cnt_rst[0] == 1) begin
        res_valid <= 0;
        cnt_rst <= 2'b00;
    end else if (res_valid_rst[0] == 1 && res_valid == 1) begin
        res_valid <= 0;
        res_valid_rst <= 2'b00;
    end else if (res_valid_rst[1] == 1 && res_valid == 1) begin
        res_valid <= 0;
        res_valid_rst <= 2'b00;
    end
end

// Update the result:
always @(posedge clk) begin
    if (res_ready == 1 && cnt == 8) begin
        result <= {shift_reg[7:0], shift_reg[15:8]};
    end
end

endmodule