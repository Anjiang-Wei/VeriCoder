reg[1:0] state;  // state register
	reg p_red,p_yellow,p_green ;//next value registers for red,yellow,and green signals

	//counter for timing purpose(8bit)
	reg[7:0] cnt; 
	assign cnt=clock&#32b_1000; //active low
	integer i;
	initial begin
		state=idle;
		cnt=0;
	end
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) state<=idle;
		else state <= {state[1:0],cnt};
    end 
	always @* begin
		p_red=state[0]; //next red signal is same as current one
		p_yellow=state[1];//next yellow signal is same as current one
		p_green=state[2];//next green signal is same as current one
		if(cnt==10) begin
			if(!p_red && !p_yellow && !p_green) red=1; //3ticks of green,then next 3ticks of yellow to start the red light
			else state[0]=state[0]+1;//decrement by 1 for each tick
		end
		else if(cnt==60) begin
			if(!p_red && !p_yellow && p_green) red=1; //3ticks of green,then next 3ticks of yellow to start the red light
			else state[0]=state[0]+1;//decrement by 1 for each tick
		end
		else if(cnt==5) begin
			if(!p_red && p_yellow && !p_green) yellow=1; //3ticks of green,then next 3ticks of yellow to start the red light
			else state[1]=state[1]+1;//decrement by 1 for each tick
		end
		else if(!p_red && !p_yellow && p_green) begin //green signal is active,so wait another 3ticks of green to start the yellow light
			if(cnt==5) state[2]=1;//next yellow signal is same as current one
			else state[2]=state[2]+1;//decrement by 1 for each tick
		end
		else if(!p_red && !p_yellow && !p_green) begin //red signal is active,so wait another 3ticks of red to start the green light
			if(cnt==10) state[2]=1;//next yellow signal is same as current one
			else state[2]=state[2]+1;//decrement by 1 for each tick
		end
		else begin //decrement by 1 for each tick
			state[0]<=state[0]+1;
			state[1]<=state[1]+1;
			state[2]<=state[2]+1;
		end
		cnt<=0; //reset counter to 10
    end 
	assign green=(state==s3_green);//active low
	assign yellow=(state==s2_yellow || state==idle);//active low
	assign red=(state==s1_red || state==idle); //active low
	assign clock={cnt,red,yellow,green}; 
endmodule