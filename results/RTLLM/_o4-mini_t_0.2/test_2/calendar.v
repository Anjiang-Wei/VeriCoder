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

    //--------------------------------------------------
    // Seconds counter: 0→59, roll over to 0
    //--------------------------------------------------
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end else begin
            Secs <= Secs + 6'd1;
        end
    end

    // -------------------------------------------------
    // Minutes counter: increments when seconds roll over
    // 0→59, roll over to 0 when both Min&Sec = 59
    // -------------------------------------------------
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (Mins == 6'd59 && Secs == 6'd59) begin
            Mins <= 6'd0;
        end else if (Secs == 6'd59) begin
            Mins <= Mins + 6'd1;
        end else begin
            Mins <= Mins;
        end
    end

    // -------------------------------------------------
    // Hours counter: increments when Min&Sec roll over
    // Counts 0→23, roll over to 0 when 23:59:59 
    // -------------------------------------------------
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
            Hours <= 6'd0;
        end else if (Mins == 6'd59 && Secs == 6'd59) begin
            Hours <= Hours + 6'd1;
        end else begin
            Hours <= Hours;
        end
    end

endmodule