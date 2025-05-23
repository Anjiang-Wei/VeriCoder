always @(posedge CLK or posedge RST)
begin
    if(RST) 
    begin
        Mins <= 6'b0;
    end
    else if(Mins == 6'b111111 && Secs == 6'b111111) 
    begin
        Mins <= 6'b0;
        Hours <= Hours + 1'b1;
    end
    else if(Secs == 6'b111111) 
    begin
        Mins <= Mins + 1'b1;
    end
end