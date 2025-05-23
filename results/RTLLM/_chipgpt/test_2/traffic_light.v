wire[1:0]state;
	reg cnt;
	reg p_red,p_yellow,p_green;
	//state transition logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt<=10;
			state<=idle;
		end
		else begin
			case(state)
				//wait 3 clocks for green signal to turn red
				idle: if(!pass_request && !green) state<==s1_red;
				//wait 3 clocks for yellow signal to turn green
				s1_red: if(!pass_request && green) state<==s3_green;
				//wait 3 clocks for yellow signal to turn red
				s2_yellow: if(yellow && !pass_request) state<==s1_red;
				//wait 3 clocks for green signal to turn yellow
				s3_green: if(!yellow && green) state<==s2_yellow;
				default:state<=idle;
			endcase
		end
	end
	assign {p_red,p_yellow,p_green} = state==idle ? 0 : state==s1_red? {1,0,0} : state==s2_yellow? {1,0,0} : state==s3_green? {0,1,0} : {1,1,0};
	//count logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) cnt<=10;
		else if(!pass_request && green) cnt<=60;
		else if(!yellow && green) cnt<=60;
		else cnt<=cnt-1;
	end
	assign clock=cnt;
	//output signal logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) green<=0;
		else if(!pass_request && !green) green<=1;
		else green<=0;
	end
	assign yellow=p_yellow;
	assign red=p_red;
  endmodule