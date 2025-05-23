module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output reg [5:0] Hours,Mins,Secs;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 0;
    end else if (Secs == 59'h3F) begin
        Secs <= 0;
    end else begin
        Secs <= Secs + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 0;
    end else if ((Mins == 59'h3F && Secs == 59'h3F)) begin
        Mins <= 0;
    end else if (Secs == 59'h3F) begin
        Mins <= Mins + 1;
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 0;
    end else if ((Hours == 59'h17 && Mins == 59'h3F && Secs == 59'h3F)) begin
        Hours <= 0;
    end else if (Mins == 59'h3F && Secs == 59'h3F) begin
        Hours <= Hours + 1;
    end else begin
        Hours <= Hours;
    end
end

endmodule