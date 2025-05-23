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

    reg [7:0] dividend_abs, divisor_abs;
    reg [15:0] SR;
    reg [3:0] cnt;
    reg start_cnt;
    wire [8:0] NEG_DIVISOR;
    wire [15:0] sub_result;
    wire carry_out;

    assign NEG_DIVISOR = {1'b1, ~divisor_abs + 1'b1};
    assign sub_result = SR[15:8] - NEG_DIVISOR[7:0];
    assign carry_out = sub_result[8];
    assign result = SR;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            SR <= 16'd0;
            dividend_abs <= 8'd0;
            divisor_abs <= 8'd0;
        end else begin
            if (opn_valid && !res_valid) begin
                dividend_abs <= (sign && dividend[7]) ? -dividend : dividend;
                divisor_abs <= (sign && divisor[7]) ? -divisor : divisor;
                SR <= {8'd0, dividend_abs};
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    SR[15:8] <= sub_result[7:0];
                    SR[7:0] <= sub_result[8] ? SR[7:0] : (SR[7:0] - divisor_abs);
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                    SR <= {SR[14:0], carry_out};
                end
            end else if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    assign result = {
        sign ^ dividend[7] ^ divisor[7],
        res_valid ? SR[7:0] : 8'd0
    };

endmodule