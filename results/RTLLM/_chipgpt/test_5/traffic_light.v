always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clock <= {8{1'b0}};
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end
    else begin
    	state <= idle;
				case(state)  
        	idle: if(!rst_n && pass_request) state<=s1_red;
        	s1_red: if(!rst_n || !pass_request) 
                            begin
                                case(p_green)
                               2'd0: state <= s3_green;
                               2'd1: begin
                                        clock[7:4] <= {1'b0, p_red}; //wait for count of 3
                                        green <= !p_green;
                                    end
                            end
        	s2_yellow: if(!rst_n || !pass_request) begin
                                clock[7:4] <= {1'b0, p_red}; //wait for count of 3
                                yellow <= !p_yellow;
                            end
        	s3_green: if(!rst_n || pass_request && !p_green) begin
                                clock[7:4] <= {1'b0, p_red}; //wait for count of 3
                                green <= !p_green;
                            end
                        else state <= s1_red;
							end
					default: state <= idle;
					endcase
    end
end

//Counter used for timing the traffic light signals.
reg[7:0] cnt;
always @(posedge clk or negedge rst_n) begin
if(!rst_n) cnt <= 10;
else if(!pass_request && green) cnt <= 60;
else if(!yellow && p_yellow) cnt <= 5;
else if(!red && p_red) cnt <= 10;
else cnt <= {cnt[7:1], 1'b0}; //wait for count of 3
end
assign clock = cnt;

//Next signal output logic.
reg[1:0] state,p_green,p_yellow,p_red;
always @(posedge clk or negedge rst_n) begin
if(!rst_n) begin
	state <= idle;
	p_green <= 1'b0;
	p_yellow <= 1'b0;
	p_red <= 1'b0;
end
else case(state)
idle: begin
	p_green <= !green;
	p_yellow <= !yellow;
	p_red <= !red;
end
s1_red: begin
	if(!rst_n || pass_request && green) p_green <= 1'b0;
	else p_green <= !green;
end
s2_yellow: begin
	if(!rst_n || pass_request && yellow) p_yellow <= 1'b0;
	else p_yellow <= !yellow;
end
s3_green: begin
	if(!rst_n || pass_request && green) p_green <= 1'b0;
	else if(!pass_request || yellow || red) p_yellow <= 1'b0;
	else p_red <= !red;
end
endcase
end
assign yellow = p_yellow;
assign red = p_red;
assign green = p_green;

endmodule