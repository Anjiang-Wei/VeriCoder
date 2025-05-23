module freq_div (
    input CLK_in,         // Input clock signal (100 MHz)
    input RST,            // Active high reset signal
    output reg CLK_50,    // Output clock signal (50 MHz)
    output reg CLK_10,    // Output clock signal (10 MHz)
    output reg CLK_1      // Output clock signal (1 MHz)
);

    reg [2:0] cnt_10;     // Counter for 10 MHz clock generation
    reg [6:0] cnt_100;    // Counter for 1 MHz clock generation

    // Initial values, ensuring outputs and counters don't start undefined
    initial begin
        CLK_50 = 0;
        CLK_10 = 0;
        CLK_1 = 0;
        cnt_10 = 0;
        cnt_100 = 0;
    end

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 0;  // Reset the 50 MHz clock
        else
            CLK_50 <= ~CLK_50;  // Toggle on every positive edge of CLK_in
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;       // Reset the 10 MHz clock
            cnt_10 <= 0;       // Reset the counter for 10 MHz
        end else begin
            if (cnt_10 == 4) begin // Divide by 10 logic: every 5 edges
                CLK_10 <= ~CLK_10; // Toggle the output clock
                cnt_10 <= 0;       // Reset the counter
            end else begin
                cnt_10 <= cnt_10 + 1; // Increment the counter
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;        // Reset the 1 MHz clock
            cnt_100 <= 0;      // Reset the counter for 1 MHz
        end else begin
            if (cnt_100 == 49) begin // Divide by 100 logic: every 50 edges
                CLK_1 <= ~CLK_1; // Toggle the output clock
                cnt_100 <= 0;    // Reset the counter
            end else begin
                cnt_100 <= cnt_100 + 1; // Increment the counter
            end
        end
    end

endmodule