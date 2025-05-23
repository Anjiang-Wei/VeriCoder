module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
input CLK_in; // input clock signal
input RST; // reset signal
output reg CLK_50; // output clock signal with frequency of CLK_in / 2
output reg CLK_10; // output clock signal with frequency of CLK_in / 10
output reg CLK_1; // output clock signal with frequency of CLK_in / 100

// counter for CLK_50 generation
counter cnt_50 (CLK_in, RST);

// counter for CLK_10 generation
counter cnt_10 (CLK_in, RST);

// counter for CLK_1 generation
counter cnt_100 (CLK_in, RST);

// logic for CLK_50 generation
always@(posedge CLK_in or negedge RST) begin
    if (!RST) begin
        CLK_50 <= 0; // reset CLK_50 to 0 on reset
    end else begin
        if (cnt_50 == 4) begin
            CLK_50 <= ~CLK_50; // toggle CLK_50 on 5th count
            cnt_50 <= 0; // reset counter
        end else begin
            cnt_50 <= cnt_50 + 1; // increment counter by 1
        end
    end
end

// logic for CLK_10 generation
always@(posedge CLK_in or negedge RST) begin
    if (!RST) begin
        CLK_10 <= 0; // reset CLK_10 to 0 on reset
    end else begin
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10; // toggle CLK_10 on 5th count
            cnt_10 <= 0; // reset counter
        end else begin
            cnt_10 <= cnt_10 + 1; // increment counter by 1
        end
    end
end

// logic for CLK_1 generation
always@(posedge CLK_in or negedge RST) begin
    if (!RST) begin
        CLK_1 <= 0; // reset CLK_1 to 0 on reset
    end else begin
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1; // toggle CLK_1 on 50th count
            cnt_100 <= 0; // reset counter
        end else begin
            cnt_100 <= cnt_100 + 1; // increment counter by 1
        end
    end
end

endmodule