module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
    end else begin
        if (Secs == 6'b111111) begin
            Secs <= 6'b0;
        end else begin
            Secs <= Secs + 1'b1;
        end
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b0;
    end else begin
        if (Mins == 6'b111111 && Secs == 6'b111111) begin
            Mins <= 6'b0;
        end else if (Secs == 6'b111111) begin
            Mins <= Mins + 1'b1;
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'b0;
    end else begin
        if (Hours == 6'b101111 && Mins == 6'b111111 && Secs == 6'b111111) begin
            Hours <= 6'b0;
        end else if (Mins == 6'b111111 && Secs == 6'b111111) begin
            Hours <= Hours + 1'b1;
        end
    end
end

endmodule