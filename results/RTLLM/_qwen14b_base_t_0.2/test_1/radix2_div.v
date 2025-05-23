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
    reg [15:0] SR; // Shift register
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt; // Counter
    reg start_cnt;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] quotient;
    reg [7:0] remainder;
    reg [7:0] temp;

    // State machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            result <= 16'b0;
        end else if (opn_valid && !res_valid) begin
            // Save inputs
            abs_dividend <= dividend;
            abs_divisor <= divisor;
            if (sign) begin
                // Signed division
                abs_dividend <= $signed(dividend) < 0 ? -dividend : dividend;
                abs_divisor <= $signed(divisor) < 0 ? -divisor : divisor;
            end else begin
                // Unsigned division
                abs_dividend <= dividend;
                abs_divisor <= divisor;
            end
            // Initialize shift register and NEG_DIVISOR
            SR <= {abs_dividend, 1'b0};
            NEG_DIVISOR <= ~abs_divisor + 1;
            start_cnt <= 1'b1;
            res_valid <= 1'b0;
        end else if (start_cnt) begin
            if (cnt == 4'b1111) begin
                // Division complete
                start_cnt <= 1'b0;
                res_valid <= 1'b1;
                result <= {remainder, quotient};
            end else begin
                // Perform division
                temp <= SR[15:8] - NEG_DIVISOR;
                if (temp[7]) begin
                    // Borrow occurred
                    SR <= {temp[6:0], SR[15:8], 1'b0};
                end else begin
                    // No borrow
                    SR <= {temp[6:0], SR[15:8], 1'b1};
                    quotient[7-cnt] <= 1'b1;
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid && res_ready) begin
            res_valid <= 1'b0;
        end
    end

endmodule