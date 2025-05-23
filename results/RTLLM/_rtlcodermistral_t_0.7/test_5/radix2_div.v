// Define constants
parameter WIDTH = 8;

// Define signals
reg [WIDTH-1:0] dividend_reg;
reg [WIDTH-1:0] divisor_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [15:0] result_reg;
reg [7:0] cnt;
reg start_cnt;
reg [7:0] neg_divisor;
reg [WIDTH-1:0] sr;
reg sign_reg;
reg signed_dividend;
reg signed_remainder;
reg signed_divisor;
reg signed_result;

// Assign initial values
assign sign_reg = sign;
assign signed_dividend = sign_reg ? $signed({{1{1'b0}}, dividend}) : $unsigned({{1{1'b0}}, dividend});
assign signed_divisor = sign_reg ? $signed({{1{1'b0}}, divisor}) : $unsigned({{1{1'b0}}, divisor});
assign signed_remainder = sign_reg ? $signed({{1{1'b0}}, remainder}) : $unsigned({{1{1'b0}}, remainder});
assign signed_result = sign_reg ? $signed({{1{1'b0}}, quotient}) : $unsigned({{1{1'b0}}, quotient});

// Assign inputs
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
        result_reg <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= signed_dividend;
        divisor_reg <= signed_divisor;
        start_cnt <= 1;
        cnt <= 1;
        neg_divisor <= ~divisor_reg + 1;
        sr <= {dividend_reg, 1'b0};
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            result_reg <= {remainder, quotient};
            res_valid <= 1;
        end else begin
            cnt <= cnt + 1;
            sr <= {signed_remainder, remainder[7]};
            if (remainder < neg_divisor) begin
                remainder <= remainder + divisor_reg;
                quotient <= quotient + 1;
            end
        end
    end else if (res_ready && res_valid) begin
        res_valid <= 0;
    end
end

// Assign output
assign result = result_reg;

endmodule