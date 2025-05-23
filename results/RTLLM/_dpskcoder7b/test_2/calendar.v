module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST)
begin
    if (RST)
    begin
        Hours <= 6'b000000;
        Mins <= 6'b000000;
        Secs <= 6'b000000;
    end
    else
    begin
        if (Secs == 6'b111111)
        begin
            Mins <= Mins + 1'b1;
            Secs <= 6'b000000;
        end
        else
        begin
            Secs <= Secs + 1'b1;
        end
        
        if (Mins == 6'b111111 && Secs == 6'b111111)
        begin
            Hours <= Hours + 1'b1;
            Mins <= 6'b000000;
        end
    end
end
endmodule