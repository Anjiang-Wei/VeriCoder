module freq_div (
    input  wire CLK_in,   // 100 MHz input clock
    input  wire RST,      // active‐high asynchronous reset
    output reg  CLK_50,   // 50  MHz output clock (÷2)
    output reg  CLK_10,   // 10  MHz output clock (÷10)
    output reg  CLK_1     //  1  MHz output clock (÷100)
);

    // counters for divide‐by‐10 and divide‐by‐100
    reg [2:0]  cnt_10;     // needs to count 0..4
    reg [5:0]  cnt_100;    // needs to count 0..49

    // Generate 50 MHz (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Generate 10 MHz (divide by 10 => toggle every 5 input cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == 3'd4) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 3'd1;
        end
    end

    // Generate 1 MHz (divide by 100 => toggle every 50 input cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1   <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 6'd1;
        end
    end

endmodule