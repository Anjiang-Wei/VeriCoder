module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;
    
    // Counters: cnt_10 for dividing by 10 (toggle every 5 cycles)
    //           cnt_100 for dividing by 100 (toggle every 50 cycles)
    reg [2:0] cnt_10;     // 3 bits are sufficient to count 0 to 4.
    reg [5:0] cnt_100;    // 6 bits to count 0 to 49.
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50  <= 1'b0;
            
            CLK_10  <= 1'b0;
            cnt_10  <= 3'd0;
            
            CLK_1   <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            // Generate CLK_50 by toggling on every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // Generate CLK_10:
            // Toggle CLK_10 when cnt_10 reaches 4 (after 5 cycles), then reset counter.
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
            
            // Generate CLK_1:
            // Toggle CLK_1 when cnt_100 reaches 49 (after 50 cycles), then reset counter.
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end
endmodule