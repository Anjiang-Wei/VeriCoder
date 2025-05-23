module calendar(CLK,RST,Hours,Mins,Secs);
    input CLK,RST;
    output [5:0] Hours,Mins,Secs;
    reg [5:0] Hours,Mins,Secs;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000;
            Mins <= 6'b000000;
            Secs <= 6'b000000;
        end else begin
            if (Secs == 6'b111111) begin
                if (Mins == 6'b111111) begin
                    if (Hours == 6'b111111) begin
                        Hours <= 6'b000000;
                    end else begin
                        Hours <= Hours + 1'b1;
                    end
                    Mins <= 6'b000000;
                end else begin
                    Mins <= Mins + 1'b1;
                end
                Secs <= 6'b000000;
            end else begin
                Secs <= Secs + 1'b1;
            end
        end
    end
endmodule