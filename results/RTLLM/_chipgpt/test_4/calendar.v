always@(posedge Clk or posedge Rst) begin
	if (Rst==1'b1)
		Hours<=4'd0;
	else if (Secs == 59'd9 || Mins == 59'd9) //Mins and Secs wrap around to 0 after max value.
		Hours<=Hours+1'b1;
	else if (Hours==23'd23 && Mins==59'd9 && Secs==59'd9)//hour wraps around to 0 after max value of hours and minutes
		Hours<=0;
	else
		Hours<=(Hours+1'b1);
end
always@(posedge Clk or posedge Rst) begin
	if (Rst==1'b1)
		Mins<=4'd0;
	else if (Secs == 59'd9 || Mins == 59'd9) //Mins and Secs wraps around to 0 after max value.
		Mins<=Mins+1'b1;
	else if ((Hours==23'd23 && Mins==59'd9 && Secs==59'd9) || (Secs == 59'd9 && Mins == 59'd9)) //hour wraps around to 0 after max value of hours and minutes.
		Mins<=0;
	else
		Mins<=(Mins+1'b1);
end
always@(posedge Clk or posedge Rst) begin
	if (Rst==1'b1)
	Secs<=4'd0;
	else if (Secs == 59'd9 || Mins == 59'd9) //Mins and Secs wraps around to 0 after max value.
	Secs<=Secs+1'b1;
	else if ((Hours==23'd23 && Mins==59'd9 && Secs==59'd9 || (Mins == 59'd9 && Secs == 59'd9))||(Hours==23'd23 && Mins == 59'd9) ) //hour wraps around to 0 after max value of hours and minutes.
	Secs<=0;
	else
		Secs<=(Secs+1'b1);
end
endmodule