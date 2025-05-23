module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;

reg [5:0] Secs; // Seconds value (0-59)
reg [5:0] Mins; // Minutes value (0-59)
reg [5:0] Hours; // Hours value (0-23)

always @(posedge CLK or posedge RST) begin
  if(RST) begin
    Secs <= 0;
    Mins <= 0;
    Hours <= 0;
  end else begin
    // Update seconds value
    if(Secs == 59) begin
      Secs <= 0;
    end else begin
      Secs <= Secs + 1;
    end

    // Update minutes value
    if(Mins == 59 && Secs == 59) begin
      Mins <= 0;
    end else if(Secs == 59) begin
      Mins <= Mins + 1;
    end

    // Update hours value
    if(Hours == 23 && Mins == 59 && Secs == 59) begin
      Hours <= 0;
    end else if(Mins == 59 && Secs == 59) begin
      Hours <= Hours + 1;
    end
  end
end

assign Hours = Hours;
assign Mins = Mins;
assign Secs = Secs;

endmodule