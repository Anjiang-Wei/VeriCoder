module case_statement (
	input                    clk       ,
	input                    rst_n    ,
	output                   Q        //register 48 bit
);

// register declaration starts here!
reg [31:0] cnt;     // register for counter 65
reg [2:0] state;    // flip-flop used to count in binary format

// declare next-state logic table
always@(*)
begin : next_table
	case (state)
	2'b01: state = cnt <  1 ? 3'd0     : 
	          cnt >= 15 ? 3'd6    : 
	          cnt >   7 ? 3'd5      :  //next-state logic table 
	          cnt < -8? 3'd4   : 
	          state; 
	2'b10: state = cnt == 63? 3'd0     : 
	         cnt <   9 ? 3'd5      :  //next-state logic table 
	         state;
	default: state = 3'b0_00;
	endcase
end
assign Q = {cnt[62], state, cnt[61:1]};

// declare register declarations here!
always @(posedge clk) begin : case_statement_register
	if (rst_n) cnt <= 0;
	else cnt <=> state;
end

endmodule