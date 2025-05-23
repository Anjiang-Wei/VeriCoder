```verilog
reg [3:0] cnt_100;
reg [3:0] cnt_10;
reg [3:0] cnt_50;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        cnt_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50;
        if (cnt_50 == 4) begin
            cnt_50 <= 0;
        end else begin
            cnt_50 <= cnt_50 + 1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 0;
        cnt_10 <= 0;
    end else begin
        CLK_10 <= ~CLK_10;
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        CLK_1 <= ~CLK_1;
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule