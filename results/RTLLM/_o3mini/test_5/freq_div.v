module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;
    
    // Counter for generating 10MHz from 100MHz (toggle after 5 clock cycles -> period = 10 cycles)
    reg [2:0] cnt_10;  
    // Counter for generating 1MHz from 100MHz (toggle after 50 clock cycles -> period = 100 cycles)
    reg [5:0] cnt_100;
    
    // CLK_50 generation: Divide by 2.
    // On every positive edge of CLK_in or RST, if RST is active, CLK_50 is set to 0.
    // Otherwise, CLK_50 is toggled.
    always @(posedge CLK_in or posedge RST)
    begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end
    
    // CLK_10 generation: Divide by 10.
    // On every positive edge of CLK_in or RST, if RST is active, CLK_10 is set to 0 and cnt_10 is reset to 0.
    // If cnt_10 equals 4, then CLK_10 is toggled and cnt_10 is reset to 0.
    // Else, increment cnt_10.
    always @(posedge CLK_in or posedge RST)
    begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end
        else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end
            else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end
    
    // CLK_1 generation: Divide by 100.
    // On every positive edge of CLK_in or RST, if RST is active, CLK_1 is set to 0 and cnt_100 is reset to 0.
    // If cnt_100 equals 49, then CLK_1 is toggled and cnt_100 is reset to 0.
    // Else, increment cnt_100.
    always @(posedge CLK_in or posedge RST)
    begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end
        else begin
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end
            else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule