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
    reg [7:0] DIVIDEND;
    reg [7:0] DIVISOR;
    reg [7:0] cnt;
    reg [7:0] start_cnt;
    reg [7:0] carry_out;
    reg [15:0] res;

    always @(posedge clk) begin
        if (rst) begin
            SR <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            DIVIDEND <= 8'b0;
            DIVISOR <= 8'b0;
            cnt <= 8'b0;
            start_cnt <= 8'b0;
            carry_out <= 8'b0;
            res <= 16'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                DIVIDEND <= dividend;
                DIVISOR <= divisor;
                if (sign) begin
                    SR <= {dividend[7], dividend[6:0]};
                    NEG_DIVISOR <= {~divisor[7], ~divisor[6:0]};
                end else begin
                    SR <= {1'b0, dividend[7:0]};
                    NEG_DIVISOR <= {1'b0, ~divisor[7:0]};
                end
                cnt <= 8'b00000001;
                start_cnt <= 8'b00000001;
            end
            if (start_cnt) begin
                if (cnt[7]) begin
                    cnt <= 8'b0;
                    start_cnt <= 8'b0;
                    res_valid <= 1'b1;
                    res <= {SR, carry_out};
                end else begin
                    cnt <= cnt + 1;
                    carry_out <= SR[0];
                    if (SR[0] == 1'b0) begin
                        SR <= {SR[7], SR[6:0]};
                        SR[0] <= NEG_DIVISOR[0];
                    end else begin
                        SR <= {SR[7], SR[6:0]};
                        SR[0] <= NEG_DIVISOR[0] ^ 1'b1;
                    end
                end
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 1'b0;
        end else begin
            if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    assign result = res;

endmodule