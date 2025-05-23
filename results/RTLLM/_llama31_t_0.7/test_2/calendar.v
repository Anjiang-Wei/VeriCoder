module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output reg [5:0] Hours; // Note that 6-bit was specified but 5-bit is used in this implementation
output reg [5:0] Mins; 
output reg [5:0] Secs;

reg [2:0] hours_reg; // Use a 3-bit register to store hours (0-23)
reg [4:0] mins_reg; // Use a 5-bit register to store minutes (0-59)

initial begin
    Hours = 0;
    Mins = 0;
    Secs = 0;
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        hours_reg <= 'd0; // Reset the hour register to 0
        mins_reg <= 'd0; // Reset the minute register to 0
        Secs <= 0;
    end else begin
        case(Secs)
            59: begin
                mins_reg <= (mins_reg == 59) ? 0 : mins_reg + 1;
                Secs <= 0;
            end
            default: Secs <= Secs + 1;
        endcase
    end
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Hours <= 'd0; // Reset the hour register to 0
        mins_reg <= 'd0; // Reset the minute register to 0
    end else begin
        case(mins_reg)
            59: begin
                hours_reg <= (hours_reg == 23 && mins_reg == 59) ? 'd0 : hours_reg + 1;
                mins_reg <= 0;
            end
            default: mins_reg <= mins_reg + 1;
        endcase
    end
end

assign Hours = hours_reg;
assign Mins = mins_reg;
assign Secs = Secs;

endmodule