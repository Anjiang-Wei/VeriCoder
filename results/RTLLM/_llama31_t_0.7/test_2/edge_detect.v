module edge_detect(
	input wire clk,	// clock signal
	input wire rst_n,  // reset signal (active low)
	input wire a,      // input signal

	output reg rise,   // output signal indicating rising edge
	output reg down    // output signal indicating falling edge
);

reg [1:0] state;     // current state of the counter
reg rise_next, down_next;

always @(posedge clk) begin
	if (!rst_n)
		state <= 2'b00;
	else begin
		case (state)
			2'b00:
				begin
					rise_next = a & (~prev_a);
					down_next = ~a & prev_a;
					state <= 2'b01;
				end
			2'b01:
				state <= 2'b10;
			2'b10:
				begin
					if (a != prev_a)
						state <= 2'b11;
					else
						state <= 2'b00;
				end
			2'b11: // wait for edge to settle
				state <= 2'b01;
		endcase
	end

	// Update output signals on the next clock cycle
	always @(posedge clk) begin
		if (!rst_n)
			begin
				rise = 1'b0;
				down = 1'b0;
			end
		else begin
			rise <= rise_next;
			down <= down_next;
		end
	end

reg prev_a; // previous value of the input signal
initial prev_a = 1'b0;

endmodule