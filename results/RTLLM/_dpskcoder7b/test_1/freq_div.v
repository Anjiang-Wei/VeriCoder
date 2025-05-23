// CLK_50 generation
always @(posedge CLK_in or posedge RST) begin
  if (RST)
    CLK_50 <= 1'b0;
  else
    CLK_50 <= ~CLK_50;
end

// CLK_10 generation
reg [3:0] cnt_10;
always @(posedge CLK_in or posedge RST) begin
  if (RST) begin
    CLK_10 <= 1'b0;
    cnt_10 <= 4'b0;
  end else begin
    if (cnt_10 == 4'd4) begin
      CLK_10 <= ~CLK_10;
      cnt_10 <= 4'b0;
    end else
      cnt_10 <= cnt_10 + 1;
  end
end

// CLK_1 generation
reg [6:0] cnt_100;
always @(posedge CLK_in or posedge RST) begin
  if (RST) begin
    CLK_1 <= 1'b0;
    cnt_100 <= 7'b0;
  end else begin
    if (cnt_100 == 7'd49) begin
      CLK_1 <= ~CLK_1;
      cnt_100 <= 7'b0;
    end else
      cnt_100 <= cnt_100 + 1;
  end
end

endmodule