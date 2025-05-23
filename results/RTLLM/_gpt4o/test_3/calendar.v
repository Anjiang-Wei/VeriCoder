module calendar(CLK, RST, Hours, Mins, Secs);
    // Declare inputs and outputs
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Internal logic for Seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset seconds to 0
            Secs <= 6'd0;
        end else begin
            if (Secs == 6'd59) begin
                // Wrap around seconds
                Secs <= 6'd0;
            end else begin
                // Increment seconds
                Secs <= Secs + 1;
            end
        end
    end

    // Internal logic for Minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset minutes to 0
            Mins <= 6'd0;
        end else begin
            if (Secs == 6'd59) begin
                if (Mins == 6'd59) begin
                    // Wrap around minutes
                    Mins <= 6'd0;
                end else begin
                    // Increment minutes
                    Mins <= Mins + 1;
                end
            end
        end
    end

    // Internal logic for Hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Reset hours to 0
            Hours <= 6'd0;
        end else begin
            if (Mins == 6'd59 && Secs == 6'd59) begin
                if (Hours == 6'd23) begin
                    // Wrap around hours
                    Hours <= 6'd0;
                end else begin
                    // Increment hours
                    Hours <= Hours + 1;
                end
            end
        end
    end

endmodule