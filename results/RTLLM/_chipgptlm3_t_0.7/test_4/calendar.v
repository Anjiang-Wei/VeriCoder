module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end
    else begin
        if (Secs == 59) begin
            Secs <= 0;
        end
        else begin
            Secs <= Secs + 1;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end
    else begin
        if (Secs == 59 && Mins == 59) begin
            Mins <= 0;
        end
        else begin
            if (Secs == 59) begin
                Mins <= Mins + 1;
            end
            else begin
                Mins <= Mins;
            end
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end
    else begin
        if (Mins == 59 && Secs == 59) begin
            Hours <= 0;
        end
        else begin
            if (Mins == 59 && Secs == 59) begin
                Hours <= Hours + 1;
            end
            else begin
                Hours <= Hours;
            end
        end
    end
end
endmodule