always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Secs <= 6'd0;
    end else begin
        if(Secs == 6'd59) begin
            Secs <= 6'd0;
            if(Mins == 6'd59) begin
                Mins <= 6'd0;
                if(Hours == 6'd23) begin
                    Hours <= 6'd0;
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