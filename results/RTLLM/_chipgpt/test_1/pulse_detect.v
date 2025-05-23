module pulse_detect(
	input clk,
	input rst_n,
	input data_in,
	output reg data_out
    ); 
    
    reg state;
    reg [1:0] cnt; //counts the number of times the data_in will toggle from 0 to 1 and back to 0 within 5 clk cycles. if it's more than 1, then it's a "pulse".
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) state <= 0; //starting point for the circuit
        else state <= {state, data_in};
    end

    always @* begin
	data_out = 1'b0;
	if(state == 2'b01) begin
		if(cnt > 1) data_out = 1'b1; //the "pulse" will be indicated by a dataout of 1 at the end cycle.
        else state <= {state, data_in}; //reset to last position if no pulse is detected (i.e. cnt is even)
	end   
	else case(state) begin
		2'b00: data_out = 1'b0;
		2'b01: cnt <= cnt - 1; //if the last state was a pulse, then it will be counted as one less and reset cnt to 1. if not, then cnt will be incremented by 1.
		2'b10: cnt <= cnt + 1;
	end
    end
    
endmodule