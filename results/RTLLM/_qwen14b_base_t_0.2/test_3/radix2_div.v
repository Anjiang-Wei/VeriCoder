module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output reg [15:0] result
);

    // Internal signals
    reg [7:0] dividend_abs, divisor_abs, neg_divisor, sr;
    reg [7:0] quotient;
    reg [7:0] remainder;
    reg [3:0] cnt;
    reg start_cnt;
    reg [7:0] temp;

    // Initialize internal signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            neg_divisor <= 8'b0;
            sr <= 8'b0;
            quotient <= 8'b0;
            remainder <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Save inputs
                dividend_abs <= dividend;
                divisor_abs <= divisor;
                // Compute absolute values and negated divisor
                if (sign) begin
                    dividend_abs <= $signed(dividend) < 0 ? -dividend : dividend;
                    divisor_abs <= $signed(divisor) < 0 ? -divisor : divisor;
                end else begin
                    dividend_abs <= dividend;
                    divisor_abs <= divisor;
                end
                neg_divisor <= ~divisor_abs + 1;
                // Initialize shift register
                sr <= {dividend_abs, 1'b0};
                cnt <= 4'b0;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 4'b1111) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    remainder <= sr[7:0];
                    quotient <= sr[15:8];
                    res_valid <= 1'b1;
                end else begin
                    // Increment counter
                    cnt <= cnt + 1;
                    // Perform subtraction
                    temp <= sr[15:8] + neg_divisor;
                    // Update shift register
                    sr <= {temp[7], temp[7:0], sr[15]};
                end
            end else if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Assign result
    always @(*) begin
        result = {remainder, quotient};
    end

endmodule