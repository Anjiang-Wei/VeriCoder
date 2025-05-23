module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST) begin
  // Initialize seconds to 0 on reset
  if (RST) begin
    Secs <= 0;
  end else if (Secs == 59) begin
    // Wrap around minutes when seconds wraps around
    Mins <= Min + 1;
  end else begin
    Secs <= Secs + 1;
  end;

  // Handle minutes
  if (RST) begin
    Mins <= 0;
  end else if (Mins == 59) begin
    // Wrap around hours when minutes wraps around
    Hours <= Hours + 1;
  end else begin
    Mins <= Mins + 1;
  end;

  // Handle hours
  if (RST) begin
    Hours <= 0;
  end else if (Hours == 23) begin
    // Wrap around when hours wraps around
    Hours <= 0;
  end else begin
    Hours <= Hours + 1;
  end;
end