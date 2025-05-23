always @(posedge CLK or posedge RST) begin
	if(RST)
	Hours<=0;
    else
        Secs<=Secs+1; 
end

always @(posedge CLK or posedge RST) begin  
	if(RST)
	Mins<=0;
    else if(Secs==59) Mins<=Mins+1;//sec=59 then min=60
    else Mins<=Mins; //min=49, 50..or any other number
end
always @(posedge CLK or posedge RST) begin  
	if(RST)
	Hours<=0;
	else if(Secs==59 && Mins==59) Hours<=Hours+1;//secs,min=59 then hours=60
    else if(Mins==23 && Secs!=0) Hours<=Hours+1; //max min=23 then max hour=24
	else Hours<=Hours;  
end 
assign Secs=(Secs<60)?Secs:0;//use modulo operation for the seconds
assign Mins=(Mins<59)?Mins+1:0; //use modulo operation for the minutes
assign Hours=Hours+1;           //max hour is 23, if less than max then hours will wrap around.  
   
endmodule