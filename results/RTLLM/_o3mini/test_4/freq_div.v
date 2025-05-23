module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input        CLK_in, RST;
    output reg   CLK_50, CLK_10, CLK_1;
    
    // Counter for CLK_10: toggle output when count reaches 4 (half period for divide-by-10)
    reg [2:0] cnt_10;  // 3 bits are sufficient (0–4)
    
    // Counter for CLK_1: toggle output when count reaches 49 (half period for divide-by-100)
    reg [5:0] cnt_100; // 6 bits are sufficient (0–49)
    
    // CLK_50 generation: output clock is divided by 2.
    // On each rising edge of CLK_in or on asynchronous reset, toggle CLK_50.
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end
    
    // CLK_10 generation: output clock is divided by 10.
    // Count from 0 to 4, and toggle CLK_10 when the counter reaches 4.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'b0;
        end else if (cnt_10 == 4) begin
            cnt_10 <= 3'b0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end
    
    // CLK_1 generation: output clock is divided by 100.
    // Count from 0 to 49, and toggle CLK_1 when the counter reaches 49.
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'b0;
        end else if (cnt_100 == 49) begin
            cnt_100 <= 6'b0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
    
endmodule