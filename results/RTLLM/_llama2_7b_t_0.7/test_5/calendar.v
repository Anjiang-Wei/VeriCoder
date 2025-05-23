module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or negedge RST) begin
  if (!RST) begin
    Secs <= 0;
  end else if (Secs == 59) begin
    Secs <= 0;
    Mins <= Mins + 1;
  end else if (Mins == 59 && Secs == 59) begin
    Mins <= Mins + 1;
    Hours <= Hours + 1;
  end else if (Hours == 23 || (Mins == 59 && Secs == 59)) begin
    Hours <= 0;
  end
end

assign Hours = Secs >> 6;
assign Mins = Secs << 1;
assign Secs = Secs + 1;