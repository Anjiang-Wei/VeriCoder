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

    reg [7:0] dividend_reg, divisor_reg;
    reg [15:0] SR;
    reg [3:0] cnt;
    reg start_cnt;
    wire [7:0] NEG_DIVISOR;
    wire [15:0] sub_result;
    wire carry_out;

    assign NEG_DIVISOR = -divisor_reg;
    assign sub_result = SR[15:8] - NEG_DIVISOR;
    assign carry_out = sub_result[8];
    assign result = SR;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            SR <= 0;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                dividend_reg <= (sign && dividend[7]) ? -dividend : dividend;
                divisor_reg <= (sign && divisor[7]) ? -divisor : divisor;
                SR <= {8'b0, (sign && dividend[7]) ? -dividend : dividend};
                start_cnt <= 1;
                cnt <= 1;
            end else if (start_cnt) begin
                if (cnt[3]) begin
                    cnt <= 0;
                    start_cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                end
                if (!carry_out) begin
                    SR <= {SR[14:0], 1'b0};
                end else begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b0};
                end
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
        end else begin
            if (start_cnt && cnt[3]) begin
                res_valid <= 1;
            end else if (res_valid && res_ready) begin
                res_valid <= 0;
            end
        end
    end

endmodule