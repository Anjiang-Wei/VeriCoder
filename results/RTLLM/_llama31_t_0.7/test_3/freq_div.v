module freq_div (
    input        CLK_in,
    input        RST,
    output       CLK_50,
    output       CLK_10,
    output       CLK_1
);

// Clock 50MHz generation
reg [23:0] cnt_50;
wire       CLK_50_p = !cnt_50[23];

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_50 <= '0;
        CLK_50 <= 1'b0;
    end else begin
        cnt_50 <= cnt_50 + 1;
        CLK_50 <= cnt_50[23];
    end
end

// Clock 10MHz generation
reg [3:0]   cnt_10;
wire       CLK_10_p = !cnt_10[3];

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_10 <= '0;
        CLK_10 <= 1'b0;
    end else begin
        if (cnt_10 == 4'd4)
            begin
                cnt_10 <= '0;
                CLK_10 <= !CLK_10;
            end
        else begin
            cnt_10 <= cnt_10 + 1;
        end
    end
end

// Clock 1MHz generation
reg [6:0]   cnt_100;
wire       CLK_1_p = !cnt_100[6];

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_100 <= '0;
        CLK_1 <= 1'b0;
    end else begin
        if (cnt_100 == 7'd49)
            begin
                cnt_100 <= '0;
                CLK_1 <= !CLK_1;
            end
        else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

assign CLK_50 = CLK_50_p;
assign CLK_10 = CLK_10_p;
assign CLK_1  = CLK_1_p;

endmodule // freq_div