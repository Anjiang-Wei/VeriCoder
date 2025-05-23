module calendar(CLK, RST, Hours, Mins, Secs);
  input CLK, RST;             // Clock and Reset inputs
  output reg [5:0] Hours, Mins, Secs;  // 6-bit outputs for Hours, Minutes, and Seconds

  // Always block for updating seconds
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Secs <= 6'b0;           // Reset seconds to 0
    end else if (Secs == 6'd59) begin
      Secs <= 6'b0;           // Wrap seconds back to 0 after 59
    end else begin
      Secs <= Secs + 1;       // Increment seconds
    end
  end

  // Always block for updating minutes
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Mins <= 6'b0;           // Reset minutes to 0
    end else if (Secs == 6'd59) begin
      if (Mins == 6'd59) begin
        Mins <= 6'b0;         // Wrap minutes back to 0 after 59
      end else begin
        Mins <= Mins + 1;     // Increment minutes when seconds hit 59
      end
    end
  end

  // Always block for updating hours
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Hours <= 6'b0;          // Reset hours to 0
    end else if (Secs == 6'd59 && Mins == 6'd59) begin
      if (Hours == 6'd23) begin
        Hours <= 6'b0;        // Wrap hours back to 0 after 23
      end else begin
        Hours <= Hours + 1;   // Increment hours when minutes and seconds hit their limits
      end
    end
  end

endmodule