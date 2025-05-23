module calendar(CLK, RST, Hours, Mins, Secs);
    // Inputs
    input CLK, RST;
    // Outputs (6 bits wide to hold values up to 59 for Secs/Mins and 23 for Hours)
    output [5:0] Hours, Mins, Secs;
    // Registers to store hours, minutes and seconds
    reg [5:0] Hours, Mins, Secs;

    // Always block for seconds update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0; // Reset seconds to 0
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 0; // Wrap around to 0 when reaching 59
            end else begin
                Secs <= Secs + 1; // Increment seconds
            end
        end
    end

    // Always block for minutes update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 0; // Reset minutes to 0
        end else begin
            if (Secs == 6'd59) begin // Update minutes only when seconds wrap around
                if (Mins == 6'd59) begin
                    Mins <= 0; // Wrap around to 0 when reaching 59
                end else begin
                    Mins <= Mins + 1; // Increment minutes
                end
            end
        end
    end

    // Always block for hours update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 0; // Reset hours to 0
        end else begin
            if (Secs == 6'd59 && Mins == 6'd59) begin // Update hours only when seconds and minutes wrap around
                if (Hours == 6'd23) begin
                    Hours <= 0; // Wrap around to 0 when reaching 23
                end else begin
                    Hours <= Hours + 1; // Increment hours
                end
            end
        end
    end

endmodule