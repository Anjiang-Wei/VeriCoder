module freq_div (CLK_in,CLK_50,CLK_10,CLK_1,RST);
input CLK_in,RST;
output reg CLK_50,CLK_10,CLK_1;
reg [1:0] cnt_10;
reg [5:0] cnt_100;

// 50MHz clock generation
always @(posedge CLK_in or posedge RST) begin
    if (RST)
        CLK_50 <= 1'b0;
    else
        CLK_50 <= ~CLK_50;
end

// 10MHz clock generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 2'b00;
    end
    else if (cnt_10 == 2'b100) begin
        CLK_10 <= ~CLK_10;
        cnt_10 <= 2'b00;
    end
    else begin
        cnt_10 <= cnt_10 + 1'b1;
    end
end

// 1MHz clock generation
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end
    else if (cnt_100 == 6'b110001) begin
        CLK_1 <= ~CLK_1;
        cnt_100 <= 6'b000000;
    end
    else begin
        cnt_100 <= cnt_100 + 1'b1;
    end
end

endmodule