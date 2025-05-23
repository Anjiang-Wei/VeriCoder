module calendar(input CLK, input RST, output reg [5:0] Hours, output reg [5:0] Mins, output reg [5:0] Secs);
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'b000000;
            Mins <= 6'b000000;
            Secs <= 6'b000000;
        end else begin
            if (Secs == 6'b111111) begin
                Mins <= Mins + 6'b000001;
                Secs <= 6'b000000;
            end else begin
                Secs <= Secs + 6'b000001;
            end
            
            if (Mins == 6'b111111 && Secs == 6'b111111) begin
                Hours <= Hours + 6'b000001;
                Mins <= 6'b000000;
            end
        end
    end
endmodule