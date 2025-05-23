module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // Always block for seconds
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 6'b0;
        end else if (Secs == 6'b100110) begin // 59 in binary
            Secs <= 6'b0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // Always block for minutes
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 6'b0;
        end else if (Mins == 6'b100110 && Secs == 6'b100110) begin // 59 in binary
            Mins <= 6'b0;
        end else if (Secs == 6'b100110) begin // 59 in binary
            Mins <= Mins + 1;
        end else begin
            Mins <= Mins;
        end
    end

    // Always block for hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b0;
        end else if (Hours == 6'b10111 && Mins == 6'b100110 && Secs == 6'b100110) begin // 23 in binary
            Hours <= 6'b0;
        end else if (Mins == 6'b100110 && Secs == 6'b100110) begin // 59 in binary
            Hours <= Hours + 1;
        end else begin
            Hours <= Hours;
        end
    end
endmodule