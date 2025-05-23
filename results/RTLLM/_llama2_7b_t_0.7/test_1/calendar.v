module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always@(posedge CLK or posedge RST) begin
    // Update seconds value
    if (RST) Secs <= 0;
    else if (Secs == 59) Secs <= 0;
    else Secs <= Secs + 1;

    // Update minutes value
    if (RST) Mins <= 0;
    else if (Mins == 59) Mins <= 0;
    else Mins <= Mins + 1;

    // Update hours value
    if (RST) Hours <= 0;
    else if (Hours == 23) Hours <= 0;
    else if (Mins == 59) Hours <= Hours + 1;
    else Hours <= Hours;
end

assign Hours = Secs / 60;
assign Mins = Secs % 60;
assign Secs = RST ? 0 : Secs - 1;