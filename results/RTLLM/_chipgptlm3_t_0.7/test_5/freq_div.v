reg [2:0] cnt_100,cnt_10,cnt_50;
always @(posedge CLK_in or posedge RST)
begin
    if (RST)
    begin
        cnt_100 <= 0;
        cnt_10 <= 0;
        cnt_50 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end
    else
    begin
        cnt_100 <= cnt_100 + 1;
        cnt_10 <= cnt_10 + 1;
        cnt_50 <= cnt_50 + 1;
        if (cnt_100 == 49)
        begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
        if (cnt_10 == 4)
        begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        if (cnt_50 == 1)
        begin
            CLK_50 <= ~CLK_50;
            cnt_50 <= 0;
        end
    end
end
endmodule