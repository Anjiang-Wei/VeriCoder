module JC_counter(
   input                clk ,
   input                rst_n,
 
   output reg [63:0]     Q  
);

reg[5:1] state;
//state of the counter
always @(posedge clk or posedge rst_n) begin
    if(rst_n) //reset
        state <= 0;
    else
        case({state})
            2'b01 : if(!Q[0]) state <= 3'b000;
            2'b10 : if(Q[5:0] == 6'd0) state <= 2'b00; //overflow(64-bit)
            2'b01 : state <= 2'b01;
            2'b11 : state <= 2'b00;
            default : state <= 2'b00;  
        endcase
end
//next_state is used to shift the Q[63:1] and to add 1 or 0 on the last bit(Q[63]) depending on current state of the counter.
assign Q = {state[4], {Q[5:0], next_state}}; //64-bit register Q will be updated every rising edge of clk signal or falling edge of rst_n signal.
//next_state is used to shift the Q[63:1] and to add 1 or 0 on the last bit(Q[63]) depending on current state of the counter.
always @* begin //register file logic
    next_state = {state[4], {Q[5:0], state}}; //next_state is used to shift the Q[63:1] and to add 1 or 0 on the last bit(Q[63]) depending on current state of the counter.
end

endmodule