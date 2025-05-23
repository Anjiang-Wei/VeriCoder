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

    // Internal signals
    reg [7:0] dividend_abs;
    reg [7:0] divisor_abs;
    reg [8:0] sr; // Shift register
    reg [7:0] neg_divisor;
    reg [3:0] cnt;
    reg start_cnt;
    reg [15:0] result_reg;

    // Determine absolute values and negated divisor
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_abs <= 8'b0;
            divisor_abs <= 8'b0;
            neg_divisor <= 8'b0;
            sr <= 9'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result_reg <= 16'b0;
        end else if (opn_valid && !res_valid) begin
            if (sign) begin
                dividend_abs <= $signed(dividend) >= 0 ? dividend : ~dividend + 1;
                divisor_abs <= $signed(divisor) >= 0 ? divisor : ~divisor + 1;
            end else begin
                dividend_abs <= dividend;
                divisor_abs <= divisor;
            end
            neg_divisor <= ~divisor_abs + 1;
            sr <= {dividend_abs, 1'b0}; // Shift left by one bit
            cnt <= 4'b0001;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 4'b1000) begin
                start_cnt <= 1'b0;
                res_valid <= 1'b1;
                result_reg <= {sr[8:1], sr[0]};
            end else begin
                cnt <= cnt + 1;
                reg [8:0] temp;
                reg carry_out;
                reg [8:0] sub_result;

                // Perform subtraction
                sub_result = sr - {neg_divisor, 1'b0};
                carry_out = sub_result[8];

                // Update shift register
                temp = {carry_out, sr[8:1]};
                sr <= (carry_out) ? temp : {sr[0], sr[8:1]};
            end
        end else if (res_valid && res_ready) begin
            res_valid <= 1'b0;
        end
    end

    // Output result
    assign result = result_reg;

endmodule