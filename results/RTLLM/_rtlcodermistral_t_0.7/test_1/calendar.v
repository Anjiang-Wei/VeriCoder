always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else begin
        if (Secs == 6'b101111) begin
            Secs <= 6'b0;
            if (Mins == 6'b101111) begin
                Mins <= 6'b0;
                if (Hours == 6'b111111) begin
                    Hours <= 6'b0;
                end else begin
                    Hours <= Hours + 1;
                end
            end else begin
                Mins <= Mins + 1;
            end
        end else begin
            Secs <= Secs + 1;
        end
    end
end