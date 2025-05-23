reg [3:0] cnt_100,cnt_10;
always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_100 <= 0;
        cnt_10 <= 0;
        CLK_50 <= 0;
        CLK_1 <= 0;
        CLK_10 <= 0;
    end else begin
        cnt_100 <= cnt_100 + 1;
        cnt_10 <= cnt_10 + 1;
        if (cnt_100 == 50) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end
        if (cnt_10 == 9) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_50 <= ~CLK_50;
        end
    end
end
endmodule