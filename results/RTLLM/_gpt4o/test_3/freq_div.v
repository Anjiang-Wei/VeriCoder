module freq_div (
    input CLK_in,     // Input clock signal
    input RST,        // Reset signal
    output reg CLK_50, // Output clock signal divided by 2
    output reg CLK_10, // Output clock signal divided by 10
    output reg CLK_1   // Output clock signal divided by 100
);

    reg [2:0] cnt_10;   // Counter for CLK_10 generation
    reg [6:0] cnt_100;  // Counter for CLK_1 generation

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;  // Reset CLK_50 to 0
        end else begin
            CLK_50 <= ~CLK_50;  // Toggle CLK_50 on every clock edge
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;      // Reset CLK_10 to 0
            cnt_10 <= 0;      // Reset counter for CLK_10
        end else begin
            if (cnt_10 == 4) begin  // Toggle CLK_10 every 5th clock edge
                CLK_10 <= ~CLK_10;  // Toggle CLK_10
                cnt_10 <= 0;        // Reset counter
            end else begin
                cnt_10 <= cnt_10 + 1;  // Increment counter
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;        // Reset CLK_1 to 0
            cnt_100 <= 0;      // Reset counter for CLK_1
        end else begin
            if (cnt_100 == 49) begin  // Toggle CLK_1 every 50th clock edge
                CLK_1 <= ~CLK_1;      // Toggle CLK_1
                cnt_100 <= 0;         // Reset counter
            end else begin
                cnt_100 <= cnt_100 + 1;  // Increment counter
            end
        end
    end

endmodule