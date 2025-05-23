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
    reg [3:0] cnt;
    reg start_cnt;
    reg [15:0] res;
    reg [15:0] res_reg;
    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            res_reg <= 0;
            state <= 0;
            cnt <= 0;
            start_cnt <= 0;
            SR <= 0;
            NEG_DIVISOR <= 0;
            DIVIDEND <= 0;
            DIVISOR <= 0;
        end else begin
            case (state)
                0: begin
                    if (opn_valid && !res_valid) begin
                        DIVIDEND <= dividend;
                        DIVISOR <= divisor;
                        if (sign) begin
                            NEG_DIVISOR <= -divisor;
                            SR <= {dividend[7], dividend};
                        end else begin
                            NEG_DIVISOR <= divisor;
                            SR <= {1'b0, dividend};
                        end
                        cnt <= 1;
                        start_cnt <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    if (cnt == 8) begin
                        cnt <= 0;
                        start_cnt <= 0;
                        res_valid <= 1;
                        res_reg <= {SR, res};
                        state <= 2;
                    end else begin
                        cnt <= cnt + 1;
                        if (sign) begin
                            if (SR[7] == 1) begin
                                if (SR >= NEG_DIVISOR) begin
                                    SR <= SR - NEG_DIVISOR;
                                    res <= {res[14:0], 1'b1};
                                end else begin
                                    SR <= SR - NEG_DIVISOR + 256;
                                    res <= {res[14:0], 1'b0};
                                end
                            end else begin
                                if (SR >= NEG_DIVISOR) begin
                                    SR <= SR - NEG_DIVISOR;
                                    res <= {res[14:0], 1'b1};
                                end else begin
                                    SR <= SR - NEG_DIVISOR + 256;
                                    res <= {res[14:0], 1'b0};
                                end
                            end
                        end else begin
                            if (SR[7] == 1) begin
                                if (SR >= DIVISOR) begin
                                    SR <= SR - DIVISOR;
                                    res <= {res[14:0], 1'b1};
                                end else begin
                                    SR <= SR - DIVISOR + 256;
                                    res <= {res[14:0], 1'b0};
                                end
                            end else begin
                                if (SR >= DIVISOR) begin
                                    SR <= SR - DIVISOR;
                                    res <= {res[14:0], 1'b1};
                                end else begin
                                    SR <= SR - DIVISOR + 256;
                                    res <= {res[14:0], 1'b0};
                                end
                            end
                        end
                        SR <= {SR[6:0], 1'b0};
                    end
                end
                2: begin
                    if (res_ready) begin
                        res_valid <= 0;
                        res_reg <= 0;
                        state <= 0;
                    end
                end
            endcase
        end
    end

    assign result = res_reg;

endmodule