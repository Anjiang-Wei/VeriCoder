```verilog
reg [3:0] cnt_50;
reg [3:0] cnt_10;
reg [3:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_50 <= 4'd0;
    end
    else begin
        CLK_50 <= ~CLK_50;
        if (cnt_50 == 4'd4) begin
            cnt_50 <= 4'd0;
        end
        else begin
            cnt_50 <= cnt_50 + 4'd1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 4'd0;
    end
    else begin
        if (cnt_10 == 4'd4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'd0;
        end
        else begin
            cnt_10 <= cnt_10 + 4'd1;
        end
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 4'd0;
    end
    else begin
        if (cnt_100 == 4'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 4'd0;
        end
        else begin
            cnt_100 <= cnt_100 + 4'd1;
        end
    end
end

endmodule