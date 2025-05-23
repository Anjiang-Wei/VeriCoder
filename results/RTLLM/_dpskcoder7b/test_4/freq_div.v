module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;
    reg [2:0] cnt_10 = 3'b000;
    reg [6:0] cnt_100 = 7'b0000000;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 3'b000;
            cnt_100 <= 7'b0000000;
        end 
        else begin
            CLK_50 <= ~CLK_50;
            cnt_100 = cnt_100 + 1'b1;
            if (cnt_100 == 7'b1111010) begin
                CLK_10 <= ~CLK_10;
                cnt_100 <= 7'b0000000;
            end
            cnt_10 = cnt_10 + 1'b1;
            if (cnt_10 == 3'b100) begin
                CLK_1 <= ~CLK_1;
                cnt_10 <= 3'b000;
            end
        end
    end
endmodule