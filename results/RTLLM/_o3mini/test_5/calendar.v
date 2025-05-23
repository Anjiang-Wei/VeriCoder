module calendar(CLK, RST, Hours, Mins, Secs);
  input CLK, RST;
  output [5:0] Hours, Mins, Secs;
  reg [5:0] Hours, Mins, Secs;

  // Always block for Seconds counter
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Secs <= 6'd0;
    else if (Secs == 6'd59)
      Secs <= 6'd0;
    else
      Secs <= Secs + 6'd1;
  end

  // Always block for Minutes counter
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Mins <= 6'd0;
    // When both Mins and Secs are at maximum, wrap Mins back to 0.
    else if ((Mins == 6'd59) && (Secs == 6'd59))
      Mins <= 6'd0;
    // When Secs rolls over (i.e. equals 59 before update), increment Mins.
    else if (Secs == 6'd59)
      Mins <= Mins + 6'd1;
    else
      Mins <= Mins;
  end

  // Always block for Hours counter
  always @(posedge CLK or posedge RST) begin
    if (RST)
      Hours <= 6'd0;
    // When Hours, Mins, and Secs are at maximum (23, 59, and 59 respectively), wrap Hours back to 0.
    else if ((Hours == 6'd23) && (Mins == 6'd59) && (Secs == 6'd59))
      Hours <= 6'd0;
    // When both Mins and Secs are at their maximum, increment Hours.
    else if ((Mins == 6'd59) && (Secs == 6'd59))
      Hours <= Hours + 6'd1;
    else
      Hours <= Hours;
  end

endmodule