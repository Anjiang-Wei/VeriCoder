module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Always block for seconds counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'd0; // Reset seconds to 0
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 6'd0; // Wrap around to 0 when Secs reaches 59
            end else begin
                Secs <= Secs + 6'd1; // Increment seconds
            end
        end
    end

    // Always block for minutes counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'd0; // Reset minutes to 0
        end else begin
            if (Secs == 6'd59) begin
                // Increment Mins when Secs reaches 59
                if (Mins == 6'd59) begin
                    Mins <= 6'd0; // Wrap around to 0 when Mins reaches 59
                end else begin
                    Mins <= Mins + 6'd1; // Increment minutes
                end
            end
        end
    end

    // Always block for hours counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0; // Reset hours to 0
        end else begin
            if (Mins == 6'd59 && Secs == 6'd59) begin
                // Increment Hours when both Mins and Secs reach 59
                if (Hours == 6'd23) begin
                    Hours <= 6'd0; // Wrap around to 0 when Hours reaches 23
                end else begin
                    Hours <= Hours + 6'd1; // Increment hours
                end
            end
        end
    end
endmodule