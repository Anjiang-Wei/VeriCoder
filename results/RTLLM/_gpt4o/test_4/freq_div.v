module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
    input CLK_in, RST;
    output reg CLK_50, CLK_10, CLK_1;

    // Counter for CLK_10 and CLK_1
    reg [2:0] cnt_10;  // 3-bit counter for CLK_10 (to count up to 4)
    reg [6:0] cnt_100; // 7-bit counter for CLK_1 (to count up to 49)

    // CLK_50 generation: Divide by 2
    always @(posedge CLK_in or posedge RST) begin
        if (RST) 
            CLK_50 <= 0;   // Reset to 0
        else 
            CLK_50 <= ~CLK_50; // Toggle the signal at every clock edge
    end

    // CLK_10 generation: Divide by 10
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;   // Reset to 0
            cnt_10 <= 0;   // Reset the counter
        end 
        else begin
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10; // Toggle the signal
                cnt_10 <= 0;       // Reset the counter
            end else begin
                cnt_10 <= cnt_10 + 1; // Increment the counter
            end
        end
    end

    // CLK_1 generation: Divide by 100
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;     // Reset to 0
            cnt_100 <= 0;   // Reset the counter
        end 
        else begin
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1; // Toggle the signal
                cnt_100 <= 0;    // Reset the counter
            end else begin
                cnt_100 <= cnt_100 + 1; // Increment the counter
            end
        end
    end
endmodule