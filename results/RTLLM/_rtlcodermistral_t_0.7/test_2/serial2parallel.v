```verilog
reg [3:0] cnt;
reg [7:0] dout_reg;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 0;
		dout_reg <= 0;
		dout_valid <= 0;
	end
	else begin
		if(din_valid) begin
			cnt <= cnt + 1;
			if(cnt == 8) begin
				dout_reg <= {din_serial, dout_reg[7:1]};
				cnt <= 0;
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
end

assign dout_parallel = dout_reg;

endmodule