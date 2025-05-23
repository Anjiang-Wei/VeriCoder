```verilog
	reg [3:0]cnt;
	reg [7:0]temp;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			cnt <= 4'd0;
			dout_parallel <= 8'd0;
			dout_valid <= 1'b0;
		end
		else begin
			if(din_valid) begin
				cnt <= cnt + 4'd1;
				temp <= {temp[6:0], din_serial};
				if(cnt == 4'd7) begin
					dout_parallel <= temp;
					dout_valid <= 1'b1;
					cnt <= 4'd0;
				end
				else begin
					dout_valid <= 1'b0;
				end
			end
		end
	end
endmodule