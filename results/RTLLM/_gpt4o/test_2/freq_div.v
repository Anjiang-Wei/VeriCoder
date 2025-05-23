module freq_div (
    input CLK_in,       // Input clock signal (100 MHz)
    input RST,          // Reset signal
    output reg CLK_50,  // Output clock signal with frequency CLK_in divided by 2 (50 MHz)
    output reg CLK_10,  // Output clock signal with frequency CLK_in divided by 10 (10 MHz)
    output reg CLK_1    // Output clock signal with frequency CLK_in divided by 100 (1 MHz)
);

    // Counter for dividing clock by 10
    reg [3:0] cnt_10;       // 4-bit counter for CLK_10 (max value 4)
    // Counter for dividing clock by 100
    reg [6:0] cnt_100;      // 7-bit counter for CLK_1 (max value 49)

    // CLK_50 generation: Toggle every positive edge of CLK_in
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;    // Reset CLK_50 to 0
        end else begin
            CLK_50 <= ~CLK_50;  // Toggle CLK_50
        end
    end

    // CLK_10 generation: Divide input clock by 10
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;    // Reset CLK_10 to 0
            cnt_10 <= 0;    // Reset counter for CLK_10
        end else begin
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;  // Toggle CLK_10 after 5 clock cycles
                cnt_10 <= 0;       // Reset counter
            end else begin
                cnt_10 <= cnt_10 + 1;  // Increment counter
            end
        end
    end

    // CLK_1 generation: Divide input clock by 100
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;     // Reset CLK_1 to 0
            cnt_100 <= 0;   // Reset counter for CLK_1
        end else begin
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;  // Toggle CLK_1 after 50 clock cycles
                cnt_100 <= 0;     // Reset counter
            end else begin
                cnt_100 <= cnt_100 + 1;  // Increment counter
            end
        end
    end

endmodule