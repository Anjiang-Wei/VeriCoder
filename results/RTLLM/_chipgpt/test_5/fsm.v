module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;
reg [1:0] S; //state register to detect the pattern 10011
reg matched; //bit for state detection (active low)
always @(posedge CLK or posedge RST) begin
    if(RST) S <= 2'b00;
    else case(S)
        2'b00: if(IN && !matched) S <= 2'b10; //when IN is 1, go to the next state. The state is a "loop" (the output signal will be 1 until the end of time).
        2'b10: if(!IN) S <= 2'b00; //stop at "one".
        2'b01: S <= 2'b00; //move to the next state.
    endcase
end
always @(posedge CLK or posedge RST) begin
    if(RST) MATCH <= 0;
    else if(!matched) MATCH <= 1;
    else matched <= ~{IN,MATCH}; //the state will be the inverse of the output bit of the previous clock edge. This is called "active low".
end
endmodule