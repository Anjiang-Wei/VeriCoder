```verilog
reg [DATA_WIDTH-1:0] reg_adda[0:STG_WIDTH-1];
reg [DATA_WIDTH-1:0] reg_addb[0:STG_WIDTH-1];
reg [DATA_WIDTH+1:0] reg_sum[0:STG_WIDTH-1];
reg [DATA_WIDTH:0] reg_carry[0:STG_WIDTH-1];
reg [STG_WIDTH-1:0] reg_cnt[0:2];

assign result = reg_sum[STG_WIDTH-1];
assign o_en = reg_cnt[2];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 0;
        reg_addb <= 0;
        reg_sum <= 0;
        reg_carry <= 0;
        reg_cnt <= 0;
        o_en <= 0;
    end
    else begin
        if (i_en) begin
            reg_adda[0] <= adda;
            reg_addb[0] <= addb;
            reg_cnt[0] <= 1;
        end

        for (reg_cnt[1] = 0; reg_cnt[1] < STG_WIDTH; reg_cnt[1] = reg_cnt[1] + 1) begin
            reg_adda[reg_cnt[1]] <= reg_adda[reg_cnt[1] - 1];
            reg_addb[reg_cnt[1]] <= reg_addb[reg_cnt[1] - 1];
            reg_sum[reg_cnt[1]] <= reg_sum[reg_cnt[1] - 1] + {reg_adda[reg_cnt[1]], reg_addb[reg_cnt[1]], reg_carry[reg_cnt[1] - 1]};
            reg_carry[reg_cnt[1]] <= (reg_sum[reg_cnt[1]] > {DATA_WIDTH{1'b1}});
        end

        reg_adda[STG_WIDTH-1] <= adda;
        reg_addb[STG_WIDTH-1] <= addb;
        reg_cnt[2] <= reg_cnt[1];
    end
end

endmodule