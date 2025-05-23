module calendar(
    input        CLK,
    input        RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

    reg [5:0] Secs;
    reg [5:0] Mins;
    reg [5:0] Hours;

    // Seconds counter: 0–59 then wrap
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end

    // Minutes counter: increment when Secs rolls over; wrap at 59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            if (Mins == 6'd59)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        // else keep Mins unchanged
    end

    // Hours counter: increment when Min & Sec roll over; wrap at 23
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if ((Secs == 6'd59) && (Mins == 6'd59)) begin
            if (Hours == 6'd23)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end
        // else keep Hours unchanged
    end

endmodule