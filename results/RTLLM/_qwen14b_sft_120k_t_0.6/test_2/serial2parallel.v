module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);
	// 4-bit counter to track the number of bits received
	reg [3:0] cnt;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 4'b0000;
			dout_parallel <= 8'b00000000;
			dout_valid <= 1'b0;
		end else if (din_valid) begin
			if (cnt == 4'b1111) begin
				// When 8 bits are received, reset counter and set dout_valid
				cnt <= 4'b0000;
				dout_valid <= 1'b1;
			end else begin
				// Shift dout_parallel left and insert din_serial
				dout_parallel <= {dout_parallel[6:0], din_serial};
				cnt <= cnt + 1'b1;
			end
		end else begin
			dout_valid <= 1'b0;
		end
	end

endmodule