module freq_div (CLK_in,CLK_50,CLK_10,CLK_1,RST);
input CLK_in,RST;
output reg CLK_50,CLK_10,CLK_1;
//CLK_50 generation
always @(posedge or reset) begin
    if (RST)
        CLK_50 <= 0;
    else
        CLK_50 <= ~CLK_50;
end
//CLK_10 generation
always @(posedge or reset) begin
    if (RST)
        CLK_10 <= 0;
    else begin
        cnt_10 <= 0;
        if (cnt_10 > 3) //if the counter cnt_10 reaches a value of 4, then toggle to inverting output
            CLK_10 <= ~CLK_10;
        else begin
            CLK_10 <= CLK_10;
            cnt_10 <= cnt_10 + 1; //Increment the counter by one on every positive edge of input clock
        end
    end
end
//CLK_1 generation
always @(posedge or reset) begin
    if (RST)
        CLK_1 <= 0;
    else begin
        cnt_100 <= 0; //Counter cnt_100 has a value of 49 initially. Then it will be decremented by one on every positive edge of input clock. If the counter reaches a value of zero, then the output is toggled to inverting output
    end
end
always @* begin
    CLK_50 <= cnt_2&CLK_in; //The counter cnt_2 has a value of 1 initially. Then it will be incremented by one on every positive edge of input clock. If the counter reaches a value of two, then toggle to inverting output
end
assign CLK_10 = cnt_3&CLK_in; //The counter cnt_3 has a value of 1 initially. Then it will be incremented by one on every positive edge of input clock. If the counter reaches a value of three, then toggle to inverting output
assign CLK_1 = cnt_4&CLK_in; //Counter cnt_4 has a value of four initially. Then it will be decremented by one on every positive edge of input clock. If the counter reaches zero, then the output is toggled to inverting output
endmodule