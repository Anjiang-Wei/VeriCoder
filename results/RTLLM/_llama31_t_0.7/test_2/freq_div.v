module freq_div (
    input  wire       CLK_in,
    input  wire       RST,
    output reg        CLK_50,
    output reg        CLK_10,
    output reg        CLK_1
);

reg [9:0] cnt_100; // Counter for 1MHz clock generation
reg [2:0] cnt_10;  // Counter for 10MHz clock generation

always @(posedge CLK_in or posedge RST)
begin
    if (RST)
    begin
        CLK_50 <= 1'b0;
        cnt_100 <= 'b0;
        cnt_10 <= 'b0;
    end
    else
    begin
        // Generate 50MHz clock
        if (!CLK_50) // Toggle on every positive edge
            CLK_50 <= ~CLK_50;

        // Generate 1MHz clock
        if (cnt_100 == 10'd49)
        begin
            CLK_1 <= ~CLK_1; // Toggle on every 10th edge
            cnt_100 <= 'b0;
        end
        else
            cnt_100 <= cnt_100 + 1;

        // Generate 10MHz clock
        if (cnt_10 == 3'd4)
        begin
            CLK_10 <= ~CLK_10; // Toggle on every 5th edge
            cnt_10 <= 'b0;
        end
        else
            cnt_10 <= cnt_10 + 1;
    end
end

endmodule