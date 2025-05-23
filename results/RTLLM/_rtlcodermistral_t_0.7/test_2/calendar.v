always @(posedge CLK, posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end else if (Mins == 59 && Secs == 59) begin
        Mins <= 0;
        Hours <= Hours + 1;
    end else if (Mins == 59 && Secs != 59) begin
        Mins <= Mins + 1;
    end else begin
        Mins <= Mins;
    end
end