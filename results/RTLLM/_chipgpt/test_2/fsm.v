wire [2:0] cs,ns;  //register for 4-bit input (1..9) and 6-bit output (17..23)
integer i;

always @(IN or CLK or RST) begin
    if(!RST) MATCH <= 0;
    else begin
        cs<=0;
        ns<=0;
        for(i=0;i<4;i=i+1)
            case(IN[i])
                1'b 1: cs<=ns;
                default: cs<=i+1; //next state will be from i+1 to 9 (i.e., next state is from 1 to 8). If the input is zero, then it will be 0-3 as expected in the FSM
            endcase
        if(ns==5 || ns==9) MATCH <= 1; //when the output of the next state is 6 or 17, the match signal is 1.
    end
end

endmodule