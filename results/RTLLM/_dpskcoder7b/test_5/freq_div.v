//CLK_50 generation
always @(posedge CLK_in or posedge RST)
    if (RST) 
        CLK_50 <= 0;
    else 
        CLK_50 <= ~CLK_50;

//CLK_10 generation
reg [2:0] cnt_10;
always @(posedge CLK_in or posedge RST)
    if (RST) 
        begin
            CLK_10 <= 0;
            cnt_10 <= 0;
        end
    else 
        begin
            cnt_10 <= cnt_10 + 1;
            if (cnt_10 == 4)
                begin
                    CLK_10 <= ~CLK_10;
                    cnt_10 <= 0;
                end
        end

//CLK_1 generation
reg [6:0] cnt_100;
always @(posedge CLK_in or posedge RST)
    if (RST) 
        begin
            CLK_1 <= 0;
            cnt_100 <= 0;
        end
    else 
        begin
            cnt_100 <= cnt_100 + 1;
            if (cnt_100 == 49)
                begin
                    CLK_1 <= ~CLK_1;
                    cnt_100 <= 0;
                end
        end
endmodule