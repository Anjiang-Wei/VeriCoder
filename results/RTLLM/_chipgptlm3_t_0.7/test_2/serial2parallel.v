reg [3:0] cnt = 4'b0000;
reg [7:0] dout_reg = 8'b00000000;
always @(posedge clk) begin
	if(!rst_n) begin
		dout_parallel <= 8'b00000000;
		dout_valid <= 0;
		cnt <= 4'b0000;
	end
	else begin
		if(din_valid) begin
			dout_reg[cnt] <= din_serial;
			cnt <= cnt + 1;
			if(cnt == 4'b1111) begin
				dout_parallel <= dout_reg;
				dout_valid <= 1;
			end
			else begin
				dout_valid <= 0;
			end
		end
		else begin
			dout_valid <= 0;
		end
	end
endmodule