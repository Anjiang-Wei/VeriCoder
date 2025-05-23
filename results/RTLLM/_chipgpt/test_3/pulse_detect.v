module pulse_detect( 
    input clk, 
    input rst_n, 
    input data_in,  
    output reg data_out   
); 

reg state;  //0 is idle, 1 is one, 2 is zero 
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) state <= 0;
	else case(state)
		0: if (data_in == 1) //if data_in becomes 1, start next tick(next cycle). This is the end of "zero".
			state <= 1;  
		1: if (data_in == 0) state <= 2;  
		2: if (data_in == 1) data_out <= 1; //if data_in becomes 1, the current pulse will end. This is the last tick of "one".
	endcase	   
end	

endmodule