module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Always block to manage seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b000000; // Reset seconds to 0
        end else begin
            if (Secs == 59) begin
                Secs <= 6'b000000; // Reset seconds to 0
            end else begin
                Secs <= Secs + 1; // Increment seconds
            end
        end
    end

    // Always block to manage minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b000000; // Reset minutes to 0
        end else begin
            if (Secs == 59) begin
                if (Mins == 59) begin
                    Mins <= 6'b000000; // Reset minutes to 0
                end else begin
                    Mins <= Mins + 1; // Increment minutes
                end
            end
        end
    end

    // Always block to manage hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000; // Reset hours to 0
        end else begin
            if (Secs == 59 && Mins == 59) begin
                if (Hours == 23) begin
                    Hours <= 6'b000000; // Reset hours to 0
                end else begin
                    Hours <= Hours + 1; // Increment hours
                end
            end
        end
    end
endmodule