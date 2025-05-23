module freq_div (CLK_in,CLK_50,CLK_10,CLK_1,RST);
input CLK_in,RST;
output reg CLK_50,CLK_10,CLK_1;

reg [2:0] cnt_100;
reg [3:0] cnt_10;

always @(posedge CLK_in or posedge RST)
begin
    if(RST)
    begin
        CLK_50 <= 1'b0;
        cnt_10 <= 4'b0;
        cnt_100 <= 3'b0;
    end
    else
    begin
        CLK_50 <= ~CLK_50;
        cnt_10 <= cnt_10 + 1;
        cnt_100 <= cnt_100 + 1;
        
        if(cnt_10 == 4'd9)
        begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end
        
        if(cnt_100 == 3'd49)
        begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 3'b0;
        end
    end
end
endmodule