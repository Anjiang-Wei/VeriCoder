module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
  input CLK_in, RST;
  output reg CLK_50, CLK_10, CLK_1;

  reg [2:0] cnt_10;     // Counter for 10MHz clock
  reg [5:0] cnt_100;    // Counter for 1MHz clock

  // Frequency Divider for 50MHz
  always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
      CLK_50 <= 0;
    end else begin
      CLK_50 <= ~CLK_50; // Toggle CLK_50
    end
  end

  // Frequency Divider for 10MHz
  always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
      CLK_10 <= 0;
      cnt_10 <= 0;
    end else begin
      if (cnt_10 == 4) begin
        CLK_10 <= ~CLK_10;  // Toggle CLK_10
        cnt_10 <= 0;        // Reset the counter
      end else begin
        cnt_10 <= cnt_10 + 1;  // Increment the counter
      end
    end
  end

  // Frequency Divider for 1MHz
  always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
      CLK_1 <= 0;
      cnt_100 <= 0;
    end else begin
      if (cnt_100 == 49) begin
        CLK_1 <= ~CLK_1;  // Toggle CLK_1
        cnt_100 <= 0;     // Reset the counter
      end else begin
        cnt_100 <= cnt_100 + 1;  // Increment the counter
      end
    end
  end

endmodule