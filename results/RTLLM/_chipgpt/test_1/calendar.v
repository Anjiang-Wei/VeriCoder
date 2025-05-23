always @(posedge CLK or posedge RST) begin
	if (RST) begin
		Hours<=0;
	end
	else begin
		if (Hours==23 && Mins==59 && Secs==59) Hours<=0;
		else if(Mins==59 && Secs==59) Mins++;
		else if(Secs==59) Secs++;
		else if (Hours!=23&&Mins!=59&&Secs!=59) Hours++;
	end
end 

endmodule