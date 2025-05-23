always @(*) begin
    green=0;
    yellow=0;
    red=0;
    case(state) 
       idle: begin
						green<=1;  //wait for a count of 3 before transitioning to s3_green state. Otherwise, it remains in s1_red state.
						yellow<=0;
						red<=0; 
       end
		s1_red: begin
						green<=0; //wait for a count of 3 before transitioning to s2_yellow state. Otherwise, it remains in s1_red state.
						yellow<=(!green);
						red<=0;
       end
		s2_yellow: begin
						green<=0; //wait for a count of 3 before transitioning to s1_red state. Otherwise, it remains in s2_yellow state.
						yellow<=(!green);
						red<=1;
       end
		s3_green: begin
						green<=1; //wait for a count of 3 before transitioning to s2_yellow state. Otherwise, it remains in s3_green state.
						yellow<=(!green);
						red<=0;
       end
    endcase
    assign clock=cnt[7:0];
    always @(posedge clk) 
        if(!rst_n) cnt <=10; //initializes counter to 10
		else if (pass_request&&green && !green) cnt<=60;//if the green signal is active and the previous green signal was active then set the counter to 60. Otherwise, it should be set to 10.
		else if (!green && yellow && !yellow) cnt<=5; //if the yellow signal is inactive and the previous yellow signal was active then set the counter to 5.
		else if (!red && yellow && !yellow) cnt<=10;//if the red signal is inactive and the previous red signal was active then set the counter to 10.
		else cnt<=cnt-1; //elsewise, just decrement it by one.
end 
endmodule