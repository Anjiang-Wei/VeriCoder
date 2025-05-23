module freq_div (CLK_in,CLK_50,CLK_10,CLK_1,RST);
input CLK_in,RST;
output reg CLK_50,CLK_10,CLK_1;

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
    end else begin
        CLK_50 <= ~CLK_50; // Divide by 2
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 1'b0;
        cnt_10 <= 2'd0;
    end else if (cnt_10 == 2'd4) begin
        CLK_10 <= ~CLK_10; // Divide by 10
        cnt_10 <= 2'd0;
    end else begin
        cnt_10 <= cnt_10 + 1'b1;
    end
end

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 1'b0;
        cnt_100 <= 6'd0;
    end else if (cnt_100 == 6'd49) begin
        CLK_1 <= ~CLK_1; // Divide by 100
        cnt_100 <= 6'd0;
    end else begin
        cnt_100 <= cnt_100 + 1'b1;
    end
end

endmodule