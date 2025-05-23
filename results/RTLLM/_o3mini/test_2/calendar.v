module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output [5:0] Hours, Mins, Secs;
    reg [5:0] Hours, Mins, Secs;
    
    // Always block for seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;                      // Reset seconds to 0
        else if (Secs == 6'd59)
            Secs <= 6'd0;                      // Wrap around seconds to 0 when reaching 59
        else
            Secs <= Secs + 6'd1;               // Increment seconds
    end

    // Always block for minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;                      // Reset minutes to 0
        else if (Mins == 6'd59 && Secs == 6'd59)
            Mins <= 6'd0;                      // Wrap around minutes to 0 when both minutes == 59 and seconds == 59
        else if (Secs == 6'd59)
            Mins <= Mins + 6'd1;               // Increment minutes when seconds wrap from 59 to 0
        else
            Mins <= Mins;                      // Hold current value otherwise
    end

    // Always block for hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 6'd0;                     // Reset hours to 0
        else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59)
            Hours <= 6'd0;                     // Wrap around hours to 0 when hours==23, minutes==59, and seconds==59
        else if (Mins == 6'd59 && Secs == 6'd59)
            Hours <= Hours + 6'd1;             // Increment hours when minutes and seconds both wrap
        else
            Hours <= Hours;                    // Hold current value otherwise
    end

endmodule