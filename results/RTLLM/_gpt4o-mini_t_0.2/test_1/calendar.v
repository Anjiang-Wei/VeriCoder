module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output reg [5:0] Hours, Mins, Secs;

    // State update for Secs
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs <= 0;
        end else if (Secs == 59) begin
            Secs <= 0;
        end else begin
            Secs <= Secs + 1;
        end
    end

    // State update for Mins
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Mins <= 0;
        end else if (Secs == 59) begin
            if (Mins == 59) begin
                Mins <= 0;  
            end else begin
                Mins <= Mins + 1;
            end
        end
    end

    // State update for Hours
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 0;
        end else if (Secs == 59 && Mins == 59) begin
            if (Hours == 23) begin
                Hours <= 0;
            end else begin
                Hours <= Hours + 1;
            end
        end
    end
endmodule