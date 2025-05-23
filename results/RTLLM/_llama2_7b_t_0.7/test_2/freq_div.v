module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
input CLK_in, RST;
output reg CLK_50, CLK_10, CLK_1;

// Initialize counters for each frequency division
always @* begin
  // CLK_50 generation
  if (RST) begin
    CLK_50 <= 0;
  end else begin
    if (CLK_in == 1) begin
      CLK_50 <= ~CLK_50;
    end else begin
      CLK_50 <= CLK_50 + 1;
    end
  end

  // CLK_10 generation
  if (RST) begin
    CLK_10 <= 0;
  end else begin
    if (CLK_in == 1) begin
      CLK_10 <= ~CLK_10;
    end else begin
      CLK_10 <= CLK_10 + 1;
    end
  end

  // CLK_1 generation
  if (RST) begin
    CLK_1 <= 0;
  end else begin
    if (CLK_in == 1) begin
      CLK_1 <= ~CLK_1;
    end else begin
      CLK_1 <= CLK_1 + 1;
    end
  end
end

endmodule