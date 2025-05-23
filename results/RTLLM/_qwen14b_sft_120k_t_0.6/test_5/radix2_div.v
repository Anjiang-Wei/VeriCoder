module radix2_div(
    input wire clk,
    input wire rst,
    input wire sign,       
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

    reg [15:0] SR;
    reg [7:0] NEG_DIVISOR;
    reg [2:0] cnt;
    reg start_cnt;
    reg [7:0] dividend_abs, divisor_abs;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else if (opn_valid && !res_valid) begin
            dividend_abs <= sign ? $signed(dividend) : dividend;
            divisor_abs <= sign ? $signed(divisor) : divisor;
            SR <= {{1'b0, dividend_abs} << 1};
            NEG_DIVISOR <= ~divisor_abs;
            cnt <= 3'b001;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 3'b100) begin
                cnt <= 3'b000;
                start_cnt <= 1'b0;
                res_valid <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                reg [15:0] result_1, result_0;
                result_1 = SR - {NEG_DIVISOR, 1'b0};
                result_0 = {{16{1'b1}}, {1'b0, SR}} + {{15{1'b1}}, 1'b0};
                SR <= {{1'b0, result_1[15]} << 15, result_1[14:0]};
            end
        end else if (res_ready) begin
            res_valid <= 1'b0;
        end
    end

    always @(*) begin
        result = {SR[15:8], SR[7:0]};
    end

endmodule