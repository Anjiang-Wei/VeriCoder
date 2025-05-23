always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 1;
    end
end