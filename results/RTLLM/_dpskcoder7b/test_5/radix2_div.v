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

    reg [15:0] quotient_remainder;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] quotient;
    reg [7:0] remainder;
    reg [7:0] reg_divisor;
    reg [7:0] reg_dividend;
    reg [2:0] cnt;
    reg start_cnt;
    reg carry_out;
    reg neg_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient_remainder <= 16'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            quotient <= 8'b0;
            remainder <= 8'b0;
            reg_divisor <= 8'b0;
            reg_dividend <= 8'b0;
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            carry_out <= 1'b0;
            neg_divisor <= 1'b0;
        end else if (opn_valid && !res_valid) begin
            abs_dividend <= (sign && dividend[7]) ? -dividend : dividend;
            abs_divisor <= (sign && divisor[7]) ? -divisor : divisor;
            reg_dividend <= abs_dividend;
            reg_divisor <= abs_divisor;
            cnt <= 3'b0;
            start_cnt <= 1'b1;
        end else if (start_cnt && cnt != 3'b111) begin
            carry_out <= reg_dividend[7];
            reg_dividend <= {1'b0, reg_dividend[7:1]} - (reg_divisor + carry_out);
            cnt <= cnt + 3'b1;
            if (cnt == 3'b111) begin
                quotient <= reg_dividend[7:0];
                remainder <= reg_dividend[15:8];
                start_cnt <= 1'b0;
            end
        end else if (res_ready && start_cnt) begin
            quotient_remainder <= {remainder, quotient};
            res_valid <= 1'b1;
        end else if (res_ready && res_valid) begin
            res_valid <= 1'b0;
        end
    end

    assign result = quotient_remainder;

endmodule