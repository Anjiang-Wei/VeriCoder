module freq_div (
  input  wire        CLK_in,
  input  wire        RST,
  output reg         CLK_50,
  output reg         CLK_10,
  output reg         CLK_1
);

// Clock 50MHz counter
reg [0:9] cnt_50;
wire     clk_50_edge;

always @(posedge CLK_in or posedge RST) begin
  if (RST) begin
    cnt_50 <= 'd0;
    CLK_50 <= 'd0;
  end else begin
    cnt_50 <= cnt_50 + 1'd1;
    clk_50_edge <= ~|~cnt_50[9];
    CLK_50 <= ~CLK_50 & clk_50_edge; // toggle on every positive edge
  end
end

// Clock 10MHz counter
reg [2:0] cnt_10;
wire     clk_10_edge;

always @(posedge CLK_in or posedge RST) begin
  if (RST) begin
    cnt_10 <= 'd0;
    CLK_10 <= 'd0;
  end else begin
    cnt_10 <= cnt_10 + 1'd1;
    clk_10_edge <= ~|~cnt_10[2];
    // toggle when counter reaches value of 4
    if (clk_10_edge)
      CLK_10 <= ~CLK_10;
  end
end

// Clock 1MHz counter
reg [6:0] cnt_100;
wire     clk_1_edge;

always @(posedge CLK_in or posedge RST) begin
  if (RST) begin
    cnt_100 <= 'd0;
    CLK_1 <= 'd0;
  end else begin
    cnt_100 <= cnt_100 + 1'd1;
    clk_1_edge <= ~|~cnt_100[6];
    // toggle when counter reaches value of 49
    if (clk_1_edge)
      CLK_1 <= ~CLK_1;
  end
end

endmodule