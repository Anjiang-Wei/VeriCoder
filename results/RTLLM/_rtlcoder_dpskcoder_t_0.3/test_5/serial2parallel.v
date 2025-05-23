reg [3:0] cnt;
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		cnt <= 4'b0;
		dout_parallel <= 8'b0;
		dout_valid <= 1'b0;
	end else begin
		if (din_valid) begin
			dout_parallel[cnt] <= din_serial;
			cnt <= cnt + 1;
			if (cnt == 4'b1111) begin
				dout_valid <= 1'b1;
			end else begin
				dout_valid <= 1'b0;
			end
		end
	end
end