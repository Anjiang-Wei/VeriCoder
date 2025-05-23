module calendar (
    input        CLK,
    input        RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

    reg [5:0] Hours;
    reg [5:0] Mins;
    reg [5:0] Secs;

    // Seconds counter: 0–59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;
        end
        else if (Secs == 6'd59) begin
            Secs <= 6'd0;
        end
        else begin
            Secs <= Secs + 6'd1;
        end
    end

    // Minutes counter: increments when seconds wrap, 0–59
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;
        end
        else if (Secs == 6'd59 && Mins == 6'd59) begin
            // both secs and mins at max => wrap minutes
            Mins <= 6'd0;
        end
        else if (Secs == 6'd59) begin
            // only on second wrap increment minutes
            Mins <= Mins + 6'd1;
        end
        else begin
            Mins <= Mins;
        end
    end

    // Hours counter: increments when minutes and seconds wrap, 0–23
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
        end
        else if (Secs == 6'd59 && Mins == 6'd59 && Hours == 6'd23) begin
            // day wrap
            Hours <= 6'd0;
        end
        else if (Secs == 6'd59 && Mins == 6'd59) begin
            // only on minute & second wrap increment hours
            Hours <= Hours + 6'd1;
        end
        else begin
            Hours <= Hours;
        end
    end

endmodule