module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Always block for seconds counting
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b0; // Reset seconds
        end else if (Secs == 59) begin
            Secs <= 6'b0; // Wrap seconds to 0 after 59
        end else begin
            Secs <= Secs + 1; // Increment seconds
        end
    end

    // Always block for minutes counting
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b0; // Reset minutes
        end else if (Secs == 59) begin
            if (Mins == 59) begin
                Mins <= 6'b0; // Wrap minutes to 0 after 59
            end else begin
                Mins <= Mins + 1; // Increment minutes
            end
        end
    end

    // Always block for hours counting
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b0; // Reset hours
        end else if (Secs == 59 && Mins == 59) begin
            if (Hours == 23) begin
                Hours <= 6'b0; // Wrap hours to 0 after 23
            end else begin
                Hours <= Hours + 1; // Increment hours
            end
        end
    end

endmodule