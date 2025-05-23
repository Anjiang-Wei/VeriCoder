module calendar(CLK, RST, Hours, Mins, Secs);
  input CLK, RST;
  output [5:0] Hours, Mins, Secs;
  reg   [5:0] Hours, Mins, Secs;
  
  // Seconds block
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Secs <= 6'd0;
    else begin
      if (Secs == 6'd59)
        Secs <= 6'd0;
      else
        Secs <= Secs + 6'd1;
    end
  end
  
  // Minutes block
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Mins <= 6'd0;
    else begin
      // When Secs==59, the mins value is updated.
      // If Mins is 59 and Secs is 59, then wrap around to 0.
      if (Secs == 6'd59) begin
        if (Mins == 6'd59)
          Mins <= 6'd0;
        else
          Mins <= Mins + 6'd1;
      end
      else
        Mins <= Mins;  // hold the same value
    end
  end
  
  // Hours block
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Hours <= 6'd0;
    else begin
      // When Minutes and Seconds are both 59, the hours value is updated.
      // Check for wrapping at the maximum hour value (23).
      if ((Mins == 6'd59) && (Secs == 6'd59)) begin
        if (Hours == 6'd23)
          Hours <= 6'd0;
        else
          Hours <= Hours + 6'd1;
      end
      else
        Hours <= Hours;  // hold the same value
    end
  end
  
endmodule