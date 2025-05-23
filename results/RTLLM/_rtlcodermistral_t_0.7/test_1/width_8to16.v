```verilog

	reg					  flag	;
	reg [7:0]			   data_lock;
	
	always@(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			valid_out <= 0;
			data_out <= 0;
			flag <= 0;
		end
		else
		begin
			if(valid_in && flag)
			begin
				data_out <= {data_lock, data_in};
				valid_out <= 1;
			end
			else if(valid_in)
			begin
				data_lock <= data_in;
				flag <= 1;
			end
			else
			begin
				flag <= 0;
			end
		end
	end
	
endmodule