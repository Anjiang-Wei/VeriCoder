module freq_div (
    input        CLK_in,
    input        RST,
    output       CLK_50,
    output       CLK_10,
    output       CLK_1
);

reg             CLK_50;
reg             CLK_10;
reg             CLK_1;
reg [7:0]      cnt_100;  // counter for 1MHz frequency
reg [2:0]      cnt_10;   // counter for 10MHz frequency

// Assignments
always @(posedge CLK_in or posedge RST)
begin
    if (RST)
    begin
        cnt_100 <= 8'd0;
        cnt_10  <= 3'd0;
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
    end
    else
    begin
        if (!CLK_50)
            CLK_50 <= 1'b1;

        if (cnt_100 == 8'd49)
        begin
            CLK_1 <= !CLK_1;
            cnt_100 <= 8'd0;
        end
        else
            cnt_100 <= cnt_100 + 1'd1;

        if (!CLK_10 && cnt_10 != 3'd4)
            cnt_10 <= cnt_10 + 1'd1;
        else if (cnt_10 == 3'd4)
        begin
            CLK_10 <= !CLK_10;
            cnt_10 <= 3'd0;
        end
    end
end

endmodule