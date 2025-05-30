module calendar(
    input        CLK,
    input        RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);
    reg [5:0] Hours;
    reg [5:0] Mins;
    reg [5:0] Secs;

    // Seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (Secs == 6'd59 && Mins == 6'd59)
            Mins <= 6'd0;
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;
        else
            Mins <= Mins;
    end

    // Hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 6'd0;
        else if (Secs == 6'd59 && Mins == 6'd59 && Hours == 6'd23)
            Hours <= 6'd0;
        else if (Secs == 6'd59 && Mins == 6'd59)
            Hours <= Hours + 6'd1;
        else
            Hours <= Hours;
    end

endmodule