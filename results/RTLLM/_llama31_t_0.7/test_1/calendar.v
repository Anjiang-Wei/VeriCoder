module calendar(CLK,RST,Hours,Mins,Secs);
input CLK,RST;
output [5:0] Hours,Mins,Secs;
reg [5:0] Hours,Mins,Secs;

always @(posedge RST or posedge CLK) begin
  if (RST)
    Secs <= 'd0;
  else
    case (Secs)
      59 : Secs <= 'd0;
      default : Secs <= Secs + 'd1;
    endcase
end

always @(posedge RST or posedge CLK) begin
  if (RST || (Mins == 59 && Secs == 59))
    Mins <= 'd0;
  else if (Secs == 59)
    Mins <= Mins + 'd1;
  end else
end

always @(posedge RST or posedge CLK) begin
  if (RST || (Hours == 23 && Mins == 59 && Secs == 59))
    Hours <= 'd0;
  else if (Mins == 59 && Secs == 59)
    Hours <= Hours + 'd1;
end

endmodule