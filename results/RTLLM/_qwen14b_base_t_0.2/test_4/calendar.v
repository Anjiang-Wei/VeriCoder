module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Always block for seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b000000; // Reset seconds to 0
        end else if (Secs == 6'b111011) begin // 59 in binary
            Secs <= 6'b000000; // Wrap around to 0
        end else begin
            Secs <= Secs + 1; // Increment seconds
        end
    end

    // Always block for minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b000000; // Reset minutes to 0
        end else if (Mins == 6'b111011 && Secs == 6'b111011) begin // 59 in binary
            Mins <= 6'b000000; // Wrap around to 0
        end else if (Secs == 6'b111011) begin // 59 in binary
            Mins <= Mins + 1; // Increment minutes
        end else begin
            Mins <= Mins; // Keep minutes unchanged
        end
    end

    // Always block for hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000; // Reset hours to 0
        end else if (Hours == 6'b010111 && Mins == 6'b111011 && Secs == 6'b111011) begin // 23 in binary
            Hours <= 6'b000000; // Wrap around to 0
        end else if (Mins == 6'b111011 && Secs == 6'b111011) begin // 59 in binary
            Hours <= Hours + 1; // Increment hours
        end else begin
            Hours <= Hours; // Keep hours unchanged
        end
    end
endmodule