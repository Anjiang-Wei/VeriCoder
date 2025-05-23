module freq_div (CLK_in,CLK_50,CLK_10,CLK_1,RST);
input CLK_in,RST;
output reg CLK_50,CLK_10,CLK_1;
reg clk,cnt_1,cnt_10,cnt_100;
always @(posedge CLK_in or posedge RST) begin
if(RST) begin
    cnt_1 <= 0;
    cnt_10 <= 0;
    cnt_100 <= 0;
end
else if(!CLK_50 && !CLK_10 && !CLK_1) begin
    clk <= ~clk;
}
else if(clk) begin
    cnt_1 <= cnt_1+1;
    cnt_10 <= cnt_10+1;
    cnt_100 <= cnt_100+1;
end
end
assign CLK_50=~(clk==cnt_1),CLK_10=~(clk==cnt_10),CLK_1=~(clk==cnt_100);
endmodule