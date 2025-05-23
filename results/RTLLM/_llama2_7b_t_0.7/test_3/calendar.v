module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or negedge RST) begin
    // Update seconds value
    if (RST) begin
        Secs <= 0;
    end else if (Secs == 59) begin
        Secs <= 0; // Wrap around to 0
    end else begin
        Secs <= Secs + 1;
    end

    // Update minutes value
    if (RST) begin
        Mins <= 0;
    end else if (Mins == 59 && Secs != 59) begin
        Mins <= Mins + 1; // Increment minutes when seconds is not 59
    end else begin
        Mins <= Mins; // Keep minutes unchanged
    end

    // Update hours value
    if (RST) begin
        Hours <= 0;
    end else if (Hours == 23 && Mins != 0) begin
        Hours <= Hours + 1; // Increment hours when minutes is not 0
    end else begin
        Hours <= Hours; // Keep hours unchanged
    end
end

output [6:0] hours, mins, secs = {Hours, Mins, Secs};