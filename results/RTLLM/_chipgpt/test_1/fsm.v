module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;
reg [1:0] state;
parameter IDLE=2'b00,
          ONE=2'b01,
          TEN=2'b10;
always @(posedge CLK) begin
if(!RST) state <= IDLE;
else begin
case (state) 
IDLE: if(IN==1) begin // If input is 1, then next state will be ONE.
MATCH<=1; //If input is 0, the next state will be TEN.
state<=ONE; // Next-state will be one with output as true.
end
ONE: if(IN==0) begin
MATCH<=0;   // If input is 1, then next state will be TEN.
state<=TEN; // Next-state will be ten with output false.
end
TEN: if(IN==1) begin    //If input is 0, the next state will be IDLE.
MATCH<=0;
state<=IDLE;
end
default: state<=IDLE;
endcase
end
end
endmodule