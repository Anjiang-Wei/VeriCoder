always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'b0;
    end else if (Hours == 6'b111111 && Mins == 6'b111111 && Secs == 6'b111111) begin
        Hours <= 6'b0;
    end else if (Mins == 6'b111111 && Secs == 6'b111111) begin
        Hours <= Hours + 1;
    end
end