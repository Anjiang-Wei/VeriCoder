module asyn_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					wclk, 
	input 					rclk,   
	input 					wrstn,  
	input					rrstn,  
	input 					winc,  
	input 			 		rinc,  
	input 		[WIDTH-1:0]	wdata,

	output wire				wfull,
	output wire				rempty,
	output wire [WIDTH-1:0]	rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);
parameter DATA_WIDTH = WIDTH;

wire					wen;
wire					ren;

reg						waddr_bin;
reg						raddr_bin;
reg						wptr_buff;
reg						rptr_buff;

reg						wptr_syn [$clog2(DEPTH)-1:0];
reg						rptr_syn [$clog2(DEPTH)-1:0];

reg [ADDR_WIDTH-1:0]		waddr_gray;
reg [ADDR_WIDTH-1:0]		raddr_gray;

wire					wfull_sig;
wire					rempty_sig;

dual_port_RAM#(
	parameter WIDTH = WIDTH,
	parameter DEPTH = DEPTH
) inst_dual_port_ram (
	.clk(wclk),
	.wen(wen),
	.ren(ren),
	.waddr(waddr_bin),
	.raddr(raddr_bin),
	.wdata(wdata),
	.rdata(rdata)
);

always @ (*)
begin
	wptr_syn = {waddr_bin, wptr_buff};
	rptr_syn = {raddr_bin, rptr_buff};

	waddr_gray = $signed({wptr_syn[ADDR_WIDTH-2], ^wptr_syn[ADDR_WIDTH-3:0]});
	raddr_gray = $signed({rptr_syn[ADDR_WIDTH-2], ^rptr_syn[ADDR_WIDTH-3:0]});

	wfull_sig = (waddr_gray == ~{$signed(raddr_gray)} && waddr_gray != 4'd0);
	rempty_sig = (raddr_gray == waddr_gray);

	wfull <= wfull_sig;
	rempty <= rempty_sig;

	if (~wrstn)
		begin
			wptr_buff <= 'd0;
			rptr_buff <= 'd0;
			waddr_bin <= 'd0;
			raddr_bin <= 'd0;
		end

	else if (winc)
		begin
			if (~wrstn)
				waddr_bin <= 1'b0;
			else
				waddr_bin <= waddr_bin + 1'b1;
		end

	else if (rinc)
		begin
			if (~rrstn)
				raddr_bin <= 1'b0;
			else
				raddr_bin <= raddr_bin + 1'b1;
		end

	assign wen = 1'b1; // Dual-port RAM requires write enable to be always high for correct operation.
	assign ren = 1'b1; // Dual-port RAM requires read enable to be always high for correct operation.

end
endmodule

// dual_port_RAM module
module dual_port_RAM#(
parameter WIDTH,
parameter DEPTH
)(
	input clk,
	input wen,
	input ren,
	input [$clog2(DEPTH)-1:0] waddr,
	input [WIDTH-1:0]	wdata,
	output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram_data [DEPTH-1:0];

always @ (posedge clk)
begin
	if (wen && wen)
		begin
			ram_data[waddr] <= wdata;
		end

	else if (ren && ren)
		begin
			rdata <= ram_data[raddr];
		end
end
endmodule