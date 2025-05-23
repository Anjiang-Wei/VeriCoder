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

    reg [7:0] SR [7:0];
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    reg [15:0] final_result;
    reg result_valid;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            result_valid <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR[0] <= {1'b0, dividend[7:1]};
                NEG_DIVISOR <= -divisor;
                cnt <= 1;
                start_cnt <= 1;
                res_valid <= 1;
            end else if (start_cnt) begin
                if (cnt[3]) begin
                    cnt <= 0;
                    start_cnt <= 0;
                    result_valid <= 1;
                    final_result[7:0] <= SR[7];
                    final_result[15:8] <= SR[0];
                end else begin
                    cnt <= cnt + 1;
                    SR[cnt-1] <= {SR[cnt-2][6:0], 1'b0} - NEG_DIVISOR[7:0];
                    SR[cnt-1][7] <= ~SR[cnt-1][7];
                end
            end else if (result_valid && res_ready) begin
                result_valid <= 0;
                res_valid <= 0;
            end
        end
    end

    assign result = final_result;

endmodule