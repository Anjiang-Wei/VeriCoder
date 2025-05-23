module multi_booth_8bit(input clk, reset, input [7:0] a, b, output reg [15:0] p, output reg rdy);

reg [7:0] multiplicand;
reg [7:0] multiplier;
reg [4:0] ctr;

always @(posedge clk or posedge reset)
begin
  if (reset) 
  begin
    multiplicand <= {{8{a[7]}}, a};
    multiplier <= {{8{b[7]}}, b};
    p <= 0;
    ctr <= 0;
    rdy <= 0;
  end
  else if (ctr < 16) 
  begin
    multiplicand <= {1'b0, multiplicand[7:1]};
    if (multiplier[ctr])
      p <= p + multiplicand;
    ctr <= ctr + 1;
  end
  else 
  begin
    rdy <= 1;
  end
end
endmodule