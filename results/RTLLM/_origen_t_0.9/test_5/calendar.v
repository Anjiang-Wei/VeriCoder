module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST)
begin
    if (RST)
        Secs <= 6'b000000;
    else if (Secs == 6'd59)
        Secs <= 6'b000000;
    else
        Secs <= Secs + 1'b1;
end

always @(posedge CLK or posedge RST)
begin
    if (RST)
        Mins <= 6'b000000;
    else if (Secs == 6'd59 && Mins == 6'd59)
        Mins <= 6'b000000;
    else if (Secs == 6'd59)
        Mins <= Mins + 1'b1;
end

always @(posedge CLK or posedge RST)
begin
    if (RST)
        Hours <= 6'b000000;
    else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59)
        Hours <= 6'b000000;
    else if (Mins == 6'd59 && Secs == 6'd59)
        Hours <= Hours + 1'b1;
end
endmodule