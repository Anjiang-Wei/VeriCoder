module freq_div (
    input CLK_in,      // Input clock signal (100MHz)
    input RST,         // Reset signal (Active High)
    output reg CLK_50, // Output clock signal (50MHz)
    output reg CLK_10, // Output clock signal (10MHz)
    output reg CLK_1   // Output clock signal (1MHz)
);

    // Counter for 10MHz clock generation
    reg [2:0] cnt_10; // 3-bit counter as we need to count up to 4 (2^3 > 4)

    // Counter for 1MHz clock generation
    reg [6:0] cnt_100; // 7-bit counter as we need to count up to 49 (2^7 > 49)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end else begin
            // CLK_50: Simply toggle every rising edge of CLK_in
            CLK_50 <= ~CLK_50;

            // CLK_10: Toggle every 10 ticks of input clock
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10; // Toggle CLK_10
                cnt_10 <= 0;       // Reset the counter
            end else begin
                cnt_10 <= cnt_10 + 1; // Increment the counter
            end

            // CLK_1: Toggle every 100 ticks of input clock
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;   // Toggle CLK_1
                cnt_100 <= 0;      // Reset the counter
            end else begin
                cnt_100 <= cnt_100 + 1; // Increment the counter
            end
        end
    end

endmodule