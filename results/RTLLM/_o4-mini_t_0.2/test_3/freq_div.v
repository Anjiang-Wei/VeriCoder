module freq_div (
    input  wire CLK_in,
    input  wire RST,       // active‑high asynchronous reset
    output reg  CLK_50,    // 100MHz / 2  =  50MHz
    output reg  CLK_10,    // 100MHz / 10 =  10MHz
    output reg  CLK_1      // 100MHz / 100 =  1MHz
);

    // counter for divide‑by‑10 (toggles every 5 input cycles)
    reg [2:0] cnt_10;
    // counter for divide‑by‑100 (toggles every 50 input cycles)
    reg [5:0] cnt_100;

    // 50MHz generation: divide by 2 by toggling every clock
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz generation: divide by 10 (toggle every 5 cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10  <= 3'd0;
        end else if (cnt_10 == 3'd4) begin
            CLK_10 <= ~CLK_10;
            cnt_10  <= 3'd0;
        end else begin
            cnt_10 <= cnt_10 + 3'd1;
        end
    end

    // 1MHz generation: divide by 100 (toggle every 50 cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1    <= 1'b0;
            cnt_100  <= 6'd0;
        end else if (cnt_100 == 6'd49) begin
            CLK_1    <= ~CLK_1;
            cnt_100  <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 6'd1;
        end
    end

endmodule