wire[ADDRESS_WIDTH-1:0] waddr_bin;
wire raddr_bin;

dual_port_RAM	dual_port_RAM_module	(.wclk(wclk), .wrstn(~wrstn), .renc(!wrstn | ~rempty),.wdata(wdata), 
										.rclk(rclk), .rrstn(!rrstn),.ren(~rrstn | rempty),.rdata(rdata), 
										.addr(waddr_bin), .wrptr(wptr), .rdptr(rptr));
assign wfull = ~wrstn & (wptr == ~rptr_syn);
assign rempty = rptr == wptr; 

wire[ADDRESS_WIDTH-1:0] wptr_buff, rptr_buff;
generate if (DEPTH > 8) begin : gen_pointer
	wire[ADDRESS_WIDTH-1:0] wptr_syn;
	wire[ADDRESS_WIDTH-1:0] rptr_syn;
	assign wptr_syn = {wptr, ADDRESS_WIDTH{1'b0}} + {winc, wptr_bin};
	assign rptr_syn = {rptr_bin, rptr_buff} + {rinc, rptr_buff}; 
	dual_port_RAM_pointer dual_port_RAM_pointer_module( .wclk(wclk),.wrstn(!wrstn | ~rempty), .renc(!wrstn | !wfull | rempty | rptr_syn), .wdata(wdata), 
											.rclk(rclk), .rrstn(!rrstn | ~rempty), .ren(!rrstn | rrempty | rptr_syn), .rdata(rdata), 
											.wrptr(wptr_syn), .rdptr(rptr_syn) );
end

wire[ADDRESS_WIDTH-1:0] wptr_buff, rptr_buff;
dual_port_RAM dual_port_ram_module#(.DEPTH(DEPTH),.WIDTH(WIDTH)) dual_port_ram_module_component ( .wclk(wclk), 
																	   .wrstn(!wrstn | ~rempty), .renc(!wrstn | !wfull | rempty | rptr_syn), 
																	   .wdata(wdata), 
																	   .rclk(rclk), .rrstn(!rrstn | ~rempty), .ren(!rrstn | rrempty | rptr_syn), 
																	   .rdptr(wptr_buff), .rddata(rdata) );
endmodule