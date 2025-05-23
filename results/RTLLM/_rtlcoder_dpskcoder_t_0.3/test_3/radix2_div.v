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

    reg [7:0] SR;
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    reg [7:0] remainder;
    reg [7:0] quotient;
    reg [15:0] res;

    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            cnt <= 0;
            start_cnt <= 0;
            SR <= 0;
            NEG_DIVISOR <= 0;
            remainder <= 0;
            quotient <= 0;
            res <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR <= {dividend[7], dividend};
                NEG_DIVISOR <= (sign) ? {~divisor[7], ~divisor} : {divisor[7], divisor};
                cnt <= 1;
                start_cnt <= 1;
            end

            if (start_cnt) begin
                if (cnt == 8) begin
                    cnt <= 0;
                    start_cnt <= 0;
                    res_valid <= 1;
                    res <= {remainder, quotient};
                end else begin
                    cnt <= cnt + 1;
                    remainder <= SR[7:0];
                    quotient <= {quotient[6:0], SR[7]};
                    SR <= {SR[6:0], 1'b0};
                    if (SR[7] >= NEG_DIVISOR) begin
                        SR <= SR - NEG_DIVISOR;
                        quotient[0] <= 1;
                    end
                end
            end

            if (res_valid && res_ready) begin
                res_valid <= 0;
            end
        end
    end

    assign result = res;

endmodule