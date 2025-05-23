module freq_div (
    input        CLK_in,
    input        RST,
    output reg   CLK_50,
    output reg   CLK_10,
    output reg   CLK_1
);

    // counter for divide-by-10 (to generate 10 MHz from 100 MHz)
    reg [2:0]  cnt_10;
    // counter for divide-by-100 (to generate 1 MHz from 100 MHz)
    reg [5:0]  cnt_100;

    //-------------------------------------------------------------------------------
    // Generate 50 MHz: divide-by-2
    //-------------------------------------------------------------------------------
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    //-------------------------------------------------------------------------------
    // Generate 10 MHz: divide-by-10
    // toggle every 5 cycles of 100 MHz
    //-------------------------------------------------------------------------------
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10  <= 1'b0;
            cnt_10  <= 3'd0;
        end
        else if (cnt_10 == 3'd4) begin
            CLK_10  <= ~CLK_10;
            cnt_10  <= 3'd0;
        end
        else begin
            cnt_10  <= cnt_10 + 3'd1;
        end
    end

    //-------------------------------------------------------------------------------
    // Generate 1 MHz: divide-by-100
    // toggle every 50 cycles of 100 MHz
    //-------------------------------------------------------------------------------
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1    <= 1'b0;
            cnt_100  <= 6'd0;
        end
        else if (cnt_100 == 6'd49) begin
            CLK_1    <= ~CLK_1;
            cnt_100  <= 6'd0;
        end
        else begin
            cnt_100  <= cnt_100 + 6'd1;
        end
    end

endmodule