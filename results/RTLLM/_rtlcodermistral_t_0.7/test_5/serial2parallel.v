// Registers for storing serial input data
reg [0:0] data_reg;
reg [2:0] cnt;

// Output data register
reg [7:0] dout_reg;

// Valid output signal register
reg dout_valid_reg;

// State machine states
parameter IDLE = 2'b00;
parameter COUNT = 2'b01;
parameter OUTPUT = 2'b10;

// State machine registers
reg [1:0] state_reg;
reg [1:0] state_next;

// State machine logic
always @(posedge clk, negedge rst_n) begin
	if (~rst_n) begin
		state_reg <= IDLE;
		cnt <= 3'b000;
		dout_reg <= 8'b00000000;
		dout_valid_reg <= 1'b0;
	end
	else begin
		state_reg <= state_next;
		case (state_reg)
			IDLE: begin
				if (din_valid) begin
					state_next = COUNT;
					cnt <= 3'b000;
					data_reg <= din_serial;
				end
				else begin
					state_next = IDLE;
				end
			end
			COUNT: begin
				if (cnt == 3'b111) begin
					state_next = OUTPUT;
					dout_reg <= {data_reg, dout_reg[7:1]};
					dout_valid_reg <= 1'b1;
				end
				else begin
					state_next = COUNT;
					cnt <= cnt + 1;
					data_reg <= din_serial;
				end
			end
			OUTPUT: begin
				if (cnt == 3'b111) begin
					state_next = IDLE;
					dout_valid_reg <= 1'b0;
				end
				else begin
					state_next = OUTPUT;
				end
			end
		endcase
	end
end

// Assign outputs
assign dout_parallel = dout_reg;
assign dout_valid = dout_valid_reg;

endmodule