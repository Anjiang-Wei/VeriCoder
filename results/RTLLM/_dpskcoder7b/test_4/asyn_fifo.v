// Instantiate Dual-Port RAM
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram (
	.wclk	(wclk),
	.rclk	(rclk),
	.wen	(wen),
	.waddr	(waddr),
	.renc	(renc),
	.raddr	(raddr),
	.wdata	(wdata),
	.rdata	(rdata)
);

// Connect Input and Output to Dual-Port RAM
assign ram.wen = winc && !wfull;
assign ram.wdata = wdata;
assign rdata = ram.rdata;