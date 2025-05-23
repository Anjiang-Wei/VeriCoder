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

    reg [8:0] SR;
    reg [8:0] NEG_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    wire [8:0] sub_result;
    wire cout;

    assign sub_result = SR - NEG_DIVISOR;
    assign cout = sub_result[8];
    assign result = {SR[7:0], dividend[7:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            SR <= 9'b0;
            NEG_DIVISOR <= 9'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR <= {1'b0, dividend[7:1]};
                NEG_DIVISOR <= {1'b1, (~divisor + 1'b1)};
                cnt <= 4'b0001;
                start_cnt <= 1'b1;
                res_valid <= 1'b1;
            end else if (start_cnt && cnt[0]) begin
                if (cnt[3]) begin
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;
                end else begin
                    cnt <= cnt + 1'b1;
                end
                
                SR <= {cout ? 1'b0 : sub_result[7:0], SR[8:1]};
            end else if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule