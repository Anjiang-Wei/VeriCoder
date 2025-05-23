module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Initialize values
    initial begin
        Hours = 6'b000000; // 0 hours
        Mins = 6'b000000;  // 0 minutes
        Secs = 6'b000000;  // 0 seconds
    end

    // Update seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b000000; // Reset seconds
        end else begin
            if (Secs == 59) begin
                Secs <= 6'b000000; // Wrap seconds
            end else begin
                Secs <= Secs + 1'b1; // Increment seconds
            end
        end
    end

    // Update minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b000000; // Reset minutes
        end else begin
            if (Secs == 59) begin
                if (Mins == 59) begin
                    Mins <= 6'b000000; // Wrap minutes
                end else begin
                    Mins <= Mins + 1'b1; // Increment minutes
                end
            end
        end
    end

    // Update hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000; // Reset hours
        end else begin
            if (Secs == 59 && Mins == 59) begin
                if (Hours == 23) begin
                    Hours <= 6'b000000; // Wrap hours
                end else begin
                    Hours <= Hours + 1'b1; // Increment hours
                end
            end
        end
    end
endmodule