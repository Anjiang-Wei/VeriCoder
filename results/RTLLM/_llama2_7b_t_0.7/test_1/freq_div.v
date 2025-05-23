module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
input CLK_in, RST;
output reg CLK_50, CLK_10, CLK_1;

// Counter for 50 MHz output
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        cnt_50 <= 0;
    end else begin
        CLK_50 <= ~CLK_50; // Invert previous value for toggle
        cnt_50 <= cnt_50 + 1;
        if (cnt_50 >= 4) begin
            CLK_50 <= ~CLK_50; // Toggle output on every 5th count
            cnt_50 <= 0;
        end
    end
end

// Counter for 10 MHz output
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_10 <= 0;
        cnt_10 <= 0;
    end else begin
        CLK_10 <= ~CLK_10; // Invert previous value for toggle
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 >= 4) begin
            CLK_10 <= ~CLK_10; // Toggle output on every 5th count
            cnt_10 <= 0;
        end
    end
end

// Counter for 1 MHz output
always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_1 <= 0;
        cnt_1 <= 0;
    end else begin
        CLK_1 <= ~CLK_1; // Invert previous value for toggle
        cnt_1 <= cnt_1 + 1;
        if (cnt_1 >= 49) begin
            CLK_1 <= ~CLK_1; // Toggle output on every 50th count
            cnt_1 <= 0;
        end
    end
end

// Reset signals for counters
always @(posedge RST) begin
    CLK_50 <= 0;
    CLK_10 <= 0;
    CLK_1 <= 0;
    cnt_50 <= 0;
    cnt_10 <= 0;
    cnt_1 <= 0;
end