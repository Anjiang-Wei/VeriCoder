```verilog

	reg 						data_lock;
	always@(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			data_out <= 16'h0;
		end
		else
		begin
			if(valid_in)
			begin
				if(data_lock)
				begin
					data_out <= {data_lock, data_in};
				end
				else
				begin
					data_lock <= data_in;
				end
			end
		end
	end

	always@(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			valid_out <= 1'b0;
		end
		else
		begin
			if(data_lock && valid_in)
			begin
				valid_out <= 1'b1;
			end
			else if(valid_in)
			begin
				valid_out <= 1'b0;
			end
		end
	end

endmodule