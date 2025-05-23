always @(posedge CLK, posedge RST) begin
    if (RST) begin
        Hours <= 6'b0;
    end else if (Hours == 6'b11111 && Mins == 6'b11111 && Secs == 6'b111110) begin
        Hours <= 6'b0;
    end else if (Hours == 6'b11111 && Mins == 6'b11111) begin
        Hours <= 6'b0;
    end else if (Mins == 6'b111110 && Secs == 6'b111110) begin
        Hours <= Hours + 1;
    end else if (Mins == 6'b11111) begin
        Hours <= Hours + 1;
    end
end