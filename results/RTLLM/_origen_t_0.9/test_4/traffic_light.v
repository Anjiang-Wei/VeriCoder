```verilog
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// State transition logic
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state <= idle;
	end else begin
		case (state)
			idle:	state <= s1_red;
			s1_red:	if (cnt == 1)	state <= s3_green;
				else	state <= s1_red;
			s2_yellow:	if (cnt == 1)	state <= s1_red;
				else	state <= s2_yellow;
			s3_green:	if (cnt == 1)	state <= s2_yellow;
				else	state <= s3_green;
			default:	state <= idle;
		endcase
	end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		cnt <= 10;
	end else begin
		if (pass_request && green) cnt <= 10;
		else if (!green && p_green) cnt <= 60;
		else if (!yellow && p_yellow) cnt <= 5;
		else if (!red && p_red) cnt <= 10;
		else cnt <= cnt - 1;
	end
end

assign clock = cnt;

// Output signal logic
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		p_red <= 1'b0;
		p_yellow <= 1'b0;
		p_green <= 1'b0;
	end else begin
		p_red <= red;
		p_yellow <= yellow;
		p_green <= green;
	end
end

always @(*) begin
	case (state)
		idle: begin
			red = 1'b0;
			yellow = 1'b0;
			green = 1'b0;
		end
		s1_red: begin
			red = 1'b1;
			yellow = 1'b0;
			green = 1'b0;
		end
		s2_yellow: begin
			red = 1'b0;
			yellow = 1'b1;
			green = 1'b0;
		end
		s3_green: begin
			red = 1'b0;
			yellow = 1'b0;
			green = 1'b1;
		end
		default: begin
			red = 1'b0;
			yellow = 1'b0;
			green = 1'b0;
		end
	endcase
end
endmodule