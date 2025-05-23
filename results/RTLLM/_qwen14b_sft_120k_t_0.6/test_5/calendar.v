module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output [5:0] Hours, Mins, Secs;
    reg [5:0] Hours, Mins, Secs;

    // Always block for seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0;  // Reset seconds to 0
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 6'd0;  // Wrap around seconds
            end else begin
                Secs <= Secs + 6'd1;  // Increment seconds
            end
        end
    end

    // Always block for minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0;  // Reset minutes to 0
        end else begin
            if (Secs == 6'd59 && Mins == 6'd59) begin
                Mins <= 6'd0;  // Wrap around minutes
            end else if (Secs == 6'd59) begin
                Mins <= Mins + 6'd1;  // Increment minutes
            end else begin
                Mins <= Mins;  // Keep minutes unchanged
            end
        end
    end

    // Always block for hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;  // Reset hours to 0
        end else begin
            if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
                Hours <= 6'd0;  // Wrap around hours
            end else if (Mins == 6'd59 && Secs == 6'd59) begin
                Hours <= Hours + 6'd1;  // Increment hours
            end else begin
                Hours <= Hours;  // Keep hours unchanged
            end
        end
    end
endmodule