reg [3:0] cnt_10;
reg [6:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // CLK_50 generation
        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
        
        // CLK_10 generation
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // CLK_50 generation
        CLK_50 <= ~CLK_50;
    end
end

endmodule