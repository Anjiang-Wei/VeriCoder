module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);

	// 4-bit counter to track the number of input data bits received
	reg [3:0] cnt;

	always @(posedge clk) begin
		if (~rst_n)
			cnt <= 'b0;
		else if (din_valid) begin
			cnt <= cnt + 1'd1;
		end
	end

	always @(posedge clk) begin
		if (~rst_n || !din_valid)
			dout_parallel <= 'b0;
		else if (cnt == 8'd8) begin
			dout_parallel <= {din_serial, din_serial, din_serial, din_serial,
								din_serial, din_serial, din_serial, din_serial};
			dout_valid <= din_valid;
			cnt <= 'b0;
		end else begin
			case (cnt)
				4'd1: dout_parallel[7] <= din_serial;
				4'd2: dout_parallel[6] <= din_serial;
				4'd3: dout_parallel[5] <= din_serial;
				4'd4: dout_parallel[4] <= din_serial;
				4'd5: dout_parallel[3] <= din_serial;
				4'd6: dout_parallel[2] <= din_serial;
				4'd7: dout_parallel[1] <= din_serial;
			endcase
		end
	end

endmodule // serial2parallel