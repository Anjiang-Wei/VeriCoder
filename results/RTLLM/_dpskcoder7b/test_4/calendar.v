module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST)
begin
    if(RST)
        Secs <= 6'b0;
    else if(Secs == 6'b111111)
        Secs <= 6'b0;
    else
        Secs <= Secs + 1'b1;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        Mins <= 6'b0;
    else if(Secs == 6'b111111 && Mins == 6'b111111)
        Mins <= 6'b0;
    else if(Secs == 6'b111111)
        Mins <= Mins + 1'b1;
end

always @(posedge CLK or posedge RST)
begin
    if(RST)
        Hours <= 6'b0;
    else if(Secs == 6'b111111 && Mins == 6'b111111 && Hours == 6'b101111)
        Hours <= 6'b0;
    else if(Secs == 6'b111111 && Mins == 6'b111111)
        Hours <= Hours + 1'b1;
end
endmodule