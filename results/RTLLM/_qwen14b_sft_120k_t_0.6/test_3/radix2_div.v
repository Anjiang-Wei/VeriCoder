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

    reg [15:0] SR;
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    reg [7:0] dividend_abs, divisor_abs;

    // Calculate absolute values of dividend and divisor
    always @(*) begin
        dividend_abs = sign ? $signed(dividend) : dividend;
        divisor_abs = $signed(divisor);
        NEG_DIVISOR = ~divisor_abs + 1'b1;
    end

    // Initialize and reset the module
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR <= {{dividend_abs[7:1]}, 1'b0}; // Shift dividend left by 1
                cnt <= 4'b0;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 4'b1111) begin
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1;
                    SR <= {SR[14:0], SR[15] ^ (SR[15:0] < NEG_DIVISOR)}; // Shift and update SR
                end
            end else if (res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Extract quotient and remainder
    assign result = {SR[15:8], SR[7:0]};

endmodule