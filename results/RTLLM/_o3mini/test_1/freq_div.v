module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);
  input CLK_in, RST;
  output reg CLK_50, CLK_10, CLK_1;
  
  // Counter for generating 10MHz clock (dividing by 10)
  // Counts from 0 to 4 then toggles CLK_10 (i.e. 5 CLK_in cycles per toggle)
  reg [2:0] cnt_10;
  
  // Counter for generating 1MHz clock (dividing by 100)
  // Counts from 0 to 49 then toggles CLK_1 (i.e. 50 CLK_in cycles per toggle)
  reg [5:0] cnt_100;
  
  // CLK_50 generation: Toggle on each CLK_in edge (divide by 2) 
  always @(posedge CLK_in or posedge RST) begin
    if (RST)
      CLK_50 <= 1'b0;
    else
      CLK_50 <= ~CLK_50;
  end
  
  // CLK_10 generation: Use a counter that toggles CLK_10 each time it reaches 4 (5 cycles)
  always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
      CLK_10 <= 1'b0;
      cnt_10 <= 3'd0;
    end
    else begin
      if (cnt_10 == 3'd4) begin
        CLK_10 <= ~CLK_10;
        cnt_10 <= 3'd0;
      end
      else begin
        cnt_10 <= cnt_10 + 3'd1;
      end
    end
  end
  
  // CLK_1 generation: Use a counter that toggles CLK_1 each time it reaches 49 (50 cycles)
  always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
      CLK_1 <= 1'b0;
      cnt_100 <= 6'd0;
    end
    else begin
      if (cnt_100 == 6'd49) begin
        CLK_1 <= ~CLK_1;
        cnt_100 <= 6'd0;
      end
      else begin
        cnt_100 <= cnt_100 + 6'd1;
      end
    end
  end
  
endmodule