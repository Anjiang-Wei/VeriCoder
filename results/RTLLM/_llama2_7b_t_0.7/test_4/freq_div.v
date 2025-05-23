module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
input CLK_in; // input clock signal
input RST; // reset signal
output reg CLK_50; // output clock signal with frequency of CLK_in/2
output reg CLK_10; // output clock signal with frequency of CLK_in/10
output reg CLK_1; // output clock signal with frequency of CLK_in/100

// counter 1 (CLK_50)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
    end else begin
        if (cnt_100 >= 4) begin
            CLK_50 <= ~CLK_50; // toggle CLK_50
            cnt_100 <= 0; // reset counter
        end else begin
            cnt_100 <= cnt_100 + 1; // increment counter
        end
    end
end

// counter 2 (CLK_10)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 0;
    end else begin
        if (cnt_10 > 4) begin
            CLK_10 <= ~CLK_10; // toggle CLK_10
            cnt_10 <= 0; // reset counter
        end else begin
            cnt_10 <= cnt_10 + 1; // increment counter
        end
    end
end

// counter 3 (CLK_1)
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 0;
    end else begin
        if (cnt_100 >= 49) begin
            CLK_1 <= ~CLK_1; // toggle CLK_1
            cnt_100 <= 0; // reset counter
        end else begin
            cnt_100 <= cnt_100 + 1; // increment counter
        end
    end
end

// synthesisable
endmodule