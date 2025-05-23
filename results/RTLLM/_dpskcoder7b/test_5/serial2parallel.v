module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);

	reg [3:0] cnt;
	reg [7:0] temp_parallel;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 4'b0000;
			temp_parallel <= 8'b00000000;
			dout_parallel <= 8'b00000000;
			dout_valid <= 1'b0;
		end
		else if (din_valid) begin
			temp_parallel[cnt] <= din_serial;
			cnt <= cnt + 1'b1;
			if (cnt == 4'b1111) begin
				dout_parallel <= temp_parallel;
				dout_valid <= 1'b1;
				cnt <= 4'b0000;
			end
		end
		else begin
			dout_valid <= 1'b0;
		end
	end
endmodule