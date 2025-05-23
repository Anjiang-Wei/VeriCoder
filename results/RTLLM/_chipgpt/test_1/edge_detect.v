wire [1:0] next_a;
assign next_a = {a,{1'b0,a}}; //Next state is the same as current state but with a flipped bit.
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) rise <= 1'b0;
	else case({next_a,a})
		2'b01: rise <= 1'b0; //Falling edge detected.
		2'b10: down <= 1'b0;
	endcase
end

endmodule