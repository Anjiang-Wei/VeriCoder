always @(posedge clk or negedge rst_n) begin
	    if(!rst_n) begin
			clock <= 0;
			red <= 0;
			yellow <= 0;
			green <= 0;
		end
		else begin
			case(state)   //state is the 2-bit register representing the current state of traffic light controller.
			idle: if(!pass_request && green==1) begin //initial state where all signals are set to 0. transition to s1_red occurs immediately.
						state <= s1_red;
					end
			s1_red: if(counter<=3) begin //sets the red signal to 1 and waits for a count of 3 before transitioning to s3_green state. otherwise, it remains in s1_red state
						if(!pass_request || green==1) begin //if(!rst_n), the counter is set to 10
							state <= idle;
						end
						else if(counter==3 && !green==1) state <= s3_green;
						else state <= s1_red;
				  end
			s2_yellow: if(counter<=3) begin //sets the yellow signal to 1 and waits for a count of 3 before transitioning to s1_red state. otherwise, it remains in s2_yellow state.
						if(!pass_request || green==1) state <= idle;
						else if(counter==3 && !green==1) state <= s1_red;
						else state <= s2_yellow;
				  end
			s3_green: if(counter<=3) begin //sets the green signal to 1 and waits for a count of 3 before transitioning to s2_yellow state. otherwise, it remains in s3_green state.
						if(!pass_request || green==1) state <= idle;
						else if(counter==3 && !green==1) state <= s2_yellow;
						else state <= s3_green;
			  end
			default: state <= idle;
		endcase
		if(!pass_request || green==1) begin //if(!rst_n), the counter is set to 10
			clock <= cnt-1;
			red <= p_red;
			yellow <= p_yellow;
			green <= p_green;
		end
		else begin //otherwise, the counter is decremented normally.
			clock <= clock-1;
			red <= ~red;
			yellow <= ~yellow;
			green <= ~green;
		end
    end
    
	reg cnt; //used as an internal counter for timing purposes 
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt<=0;
		end
		else if(!pass_request || green==1) cnt <= 10; //if(!rst_n), the counter is set to 10. if the pass_request signal is active and the green signal is active, the counter is set to 10. otherwise, it remains in idle state
		else if(green==1 && !p_green) cnt <= 60; //if the green signal is inactive and the previous green signal (p_green) was active, the counter is set to 60.
		else if(yellow==1 && !p_yellow) cnt <= 5; //if the yellow signal is inactive and the previous yellow signal (p_yellow) was active, the counter is set to 5
		else if(red==1 && !p_red) cnt <= 3; //otherwise, the counter is decremented normally.
	end
	always @* begin //used as a register for p_red..p_green signal
		state=0;
		counter=0;
		wait();
		pass_request=(!yellow && !green); //signal of pass_request is 1 if yellow and green both are 0. this means "if the light has turned red, wait for it to turn green again." 
	end
	assign p_red=red; //used as signal for red signal.
	assign p_yellow=yellow; //used as signal for yellow signal.
	assign p_green=green; //used as signal for green signal.

endmodule