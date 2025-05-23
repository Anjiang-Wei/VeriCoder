module fsm(
    input IN,
    output MATCH,
    input CLK,
    input RST
);

reg [3:0] state_nxt,state_cur; //fsm state is 4-bit and will become 9 when inactive
reg match_en;
integer i;

//FSM register operation
always @(posedge CLK or negedge RST) begin
    if(!RST)
        state_nxt <= 0; //if active, becomes inactive by default and waits for next clock edge
    else
        state_nxt <= state_cur;
end
//FSM register operation
always @* begin
    match_en = 1'b0;
    i = 0;
    
    if(state_cur == 8) //when inactive, the first input will trigger an activity
        match_en = 1'b1;
        
    case({IN,state_cur})
        //output is set to MATCH when IN becomes 1 (matching sequence of inputs)
        2'd0: begin
            if(state_cur == 9 || state_cur == 8) //when inactive, the first input will trigger an activity
                match_en = 1'b1;
            else if(~match_en && IN == 1)   //if current active input is also a matching sequence of inputs, set MATCH to 1
                i = i+1;
            else if(match_en && i > 0)     //else if the current input is not a matching sequence of inputs, but the previous one was, then set MATCH to 1
                match_en = 1'b0;
        end
        2'd1: begin
            if(state_cur == 9 || state_cur == 8) //when inactive, the first input will trigger an activity
                match_en = 1'b1;
            else if(~match_en && IN == 0)   //if current active input is also a matching sequence of inputs, set MATCH to 1
                i = i+1;
            else if(match_en && i > 0)     //else if the current input is not a matching sequence of inputs, but the previous one was, then set MATCH to 1
                match_en = 1'b0;
        end
        2'd2: begin
            if(state_cur == 9 || state_cur == 8) //when inactive, the first input will trigger an activity
                match_en = 1'b1;
            else if(~match_en && IN == 0)   //if current active input is also a matching sequence of inputs, set MATCH to 1
                i = i+1;
            else if(match_en && i > 0)     //else if the current input is not a matching sequence of inputs, but the previous one was, then set MATCH to 1
                match_en = 1'b0;
        end
        2'd3: begin
            if(state_cur == 9 || state_cur == 8) //when inactive, the first input will trigger an activity
                match_en = 1'b1;
            else if(~match_en && IN == 0)   //if current active input is also a matching sequence of inputs, set MATCH to 1
                i = i+1;
            else if(match_en && i > 0)     //else if the current input is not a matching sequence of inputs, but the previous one was, then set MATCH to 1
                match_en = 1'b0;
        end
    endcase
end
assign MATCH = match_en?1:0;

endmodule