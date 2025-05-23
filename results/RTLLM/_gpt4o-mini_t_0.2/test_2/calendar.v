module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b000000;  // Reset seconds to 0
        end else begin
            if (Secs == 6'd59) begin
                Secs <= 6'b000000;  // Wrap around seconds
            end else begin
                Secs <= Secs + 1;    // Increment seconds
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b000000;  // Reset minutes to 0
        end else begin
            if (Secs == 6'd59) begin
                if (Mins == 6'd59) begin
                    Mins <= 6'b000000;  // Wrap around minutes
                end else begin
                    Mins <= Mins + 1;    // Increment minutes
                end
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000;  // Reset hours to 0
        end else begin
            if (Secs == 6'd59 && Mins == 6'd59) begin
                if (Hours == 6'd23) begin
                    Hours <= 6'b000000;  // Wrap around hours
                end else begin
                    Hours <= Hours + 1;    // Increment hours
                end
            end
        end
    end
endmodule