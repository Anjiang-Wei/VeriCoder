always @(posedge CLK or posedge RST)
begin
    if(RST)
        Hours <= 6'b0;
    else if(Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59)
        Hours <= 6'b0;
    else if(Mins == 6'd59 && Secs == 6'd59)
        Hours <= Hours + 1;
end