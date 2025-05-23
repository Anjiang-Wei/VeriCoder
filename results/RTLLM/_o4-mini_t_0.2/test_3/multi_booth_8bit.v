`timescale 1ns / 1ps
module multi_booth_8bit (
    output reg [15:0] p,
    output reg        rdy,
    input             clk,
    input             reset,
    input      [7:0]  a,  // multiplicand
    input      [7:0]  b   // multiplier
);

  // internal sign-extended copies
  reg [15:0] multiplicand;
  reg [15:0] multiplier;
  reg [4:0]  ctr;       // up to 16 cycles

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // load sign-extended operands
      multiplicand <= {{8{a[7]}}, a};
      multiplier   <= {{8{b[7]}}, b};
      p            <= 16'd0;
      ctr          <= 5'd0;
      rdy          <= 1'b0;
    end
    else if (!rdy) begin
      if (ctr < 5'd16) begin
        // if current bit of multiplier = 1, add shifted multiplicand
        if (multiplier[ctr])
          p <= p + (multiplicand << ctr);
        ctr <= ctr + 5'd1;
      end
      else begin
        // done
        rdy <= 1'b1;
      end
    end
  end

endmodule