module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST) begin
    if (RST)
        Secs <= 6'b000000;
    else if (Secs == 6'b111011)
        Secs <= 6'b000000;
    else
        Secs <= Secs + 1;
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        Mins <= 6'b000000;
    else if (Secs == 6'b111011 && Mins == 6'b111011)
        Mins <= 6'b000000;
    else if (Secs == 6'b111011)
        Mins <= Mins + 1;
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        Hours <= 6'b000000;
    else if (Hours == 6'b001011 && Mins == 6'b111011 && Secs == 6'b111011)
        Hours <= 6'b000000;
    else if (Mins == 6'b111011 && Secs == 6'b111011)
        Hours <= Hours + 1;
end
endmodule