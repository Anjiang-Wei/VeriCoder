module calendar(CLK, RST, Hours, Mins, Secs);
  input CLK, RST;
  output reg [5:0] Hours, Mins, Secs;

  // Always block for seconds
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Secs <= 6'b0;  // Reset seconds to 0
    end else if (Secs == 6'd59) begin
      Secs <= 6'b0;  // If seconds reach 59, reset to 0
    end else begin
      Secs <= Secs + 6'b1;  // Increment seconds
    end
  end

  // Always block for minutes
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Mins <= 6'b0;  // Reset minutes to 0
    end else if (Secs == 6'd59) begin  // Increment minutes only when seconds are 59
      if (Mins == 6'd59) begin
        Mins <= 6'b0;  // If minutes reach 59, reset to 0
      end else begin
        Mins <= Mins + 6'b1;  // Increment minutes
      end
    end
  end

  // Always block for hours
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      Hours <= 6'b0;  // Reset hours to 0
    end else if (Secs == 6'd59 && Mins == 6'd59) begin  // Increment hours only when both seconds and minutes are 59
      if (Hours == 6'd23) begin
        Hours <= 6'b0;  // If hours reach 23, reset to 0
      end else begin
        Hours <= Hours + 6'b1;  // Increment hours
      end
    end
  end
endmodule