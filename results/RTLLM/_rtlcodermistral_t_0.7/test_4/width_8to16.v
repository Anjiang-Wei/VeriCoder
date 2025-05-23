```verilog

	reg [7:0] 				data_lock;
	reg [7:0] 				data_in1;
	reg 						flag;

	always@(posedge clk, negedge rst_n)
	begin
		if(!rst_n)
		begin
			data_out <= 16'b0;
			valid_out <= 1'b0;
		end
		else
		begin
			if(valid_in && flag)
			begin
				data_out <= {data_lock, data_in};
				valid_out <= 1'b1;
			end
			if(valid_in && !flag)
			begin
				data_lock <= data_in;
				flag <= 1'b1;
			end
			if(!valid_in && flag)
			begin
				data_out <= {data_lock, data_in1};
				valid_out <= 1'b1;
			end
			if(!valid_in && !flag)
			begin
				data_in1 <= data_in;
			end
		end
	end

endmodule