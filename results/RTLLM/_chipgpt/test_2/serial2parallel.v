module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);
	 // Counter block
	 localparam [3:0] CNT_8 = 8'b1111_1111;
	 localparam [3:0] CNT_9 = 9'b1111_1111_1111;
	 reg [3:0] cnt;

	 always @(posedge clk) begin
		if (rst_n) cnt <= 0;
		else case (cnt)
			3'b????_: cnt <= 4'b1111; // next-state is "1" if the counter has reached 8 bits, or "0" otherwise.
			5'b???1_: cnt <= din_valid && !din_valid ? 3'b111 : (cnt == CNT_8) ? CNT_9 : cnt + 1; // If the counter has not reached the maximum count of 8 bits, then next-state is "1". Otherwise, next-state will be 0.
		endcase
	 end

	 always @(posedge clk) begin
		dout_parallel <= din_serial; // Dout_parallel will output the serial input bit when din_valid is high and cnt has reached a count of 8 bits. If it hasn't, then dout_parallel will remain zero until the counter reaches 8. Therefore, dout_valid must be checked first before any data can be outputted.
		dout_valid <= din_valid && (cnt == CNT_8); // Next-state depends on whether or not cnt has reached a count of 8 bits. If it hasn't, then next-state will be "0", meaning that dout_parallel remains at 0 until the counter reaches 8 bits.
	 end

endmodule