module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input      CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;
    
    // Counter for generating CLK_10 (divide by 10)
    reg [2:0] cnt_10;  // 3 bits can count up to 7, we need to count to 4
    
    // Counter for generating CLK_1 (divide by 100)
    reg [5:0] cnt_100; // 6 bits can count up to 63, we need to count to 49
    
    // Generate CLK_50: Simply toggle on every positive edge 
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end
    
    // Generate CLK_10: Toggle every time cnt_10 reaches 4 (i.e. every 5 cycles).
    // This results in a period of 10 cycles for CLK_10.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'b0;
        end
        else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end
    
    // Generate CLK_1: Toggle every time cnt_100 reaches 49 (i.e. every 50 cycles).
    // This results in a period of 100 cycles for CLK_1.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1   <= 1'b0;
            cnt_100 <= 6'b0;
        end
        else begin
            if (cnt_100 == 6'd49) begin
                CLK_1   <= ~CLK_1;
                cnt_100 <= 6'b0;
            end
            else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end
    
endmodule