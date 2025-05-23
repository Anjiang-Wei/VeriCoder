module asyn_fifo#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input                  wclk,    // Write Clock
	input                  rclk,    // Read Clock
	input                  wrstn,   // Write Reset, Active Low
	input                  rrstn,   // Read Reset, Active Low
	input                  winc,    // Write Increment (Write Enable)
	input                  rinc,    // Read Increment (Read Enable)
	input      [WIDTH-1:0] wdata,   // Write Data

	output wire            wfull,   // Write Full Signal
	output wire            rempty,  // Read Empty Signal
	output wire [WIDTH-1:0] rdata   // Read Data
);

	// Local parameters and address width
	parameter ADDR_WIDTH = $clog2(DEPTH);

	// Internal signals for write/read pointers in binary and Gray code
	reg [ADDR_WIDTH:0] wptr_bin, wptr_gray, wptr_gray_next;
	reg [ADDR_WIDTH:0] rptr_bin, rptr_gray, rptr_gray_next;

	// Synchronized write/read pointers (Gray code)
	reg [ADDR_WIDTH:0] wptr_syn_rclk;  // Write pointer synchronized to rclk
	reg [ADDR_WIDTH:0] rptr_syn_wclk;  // Read pointer synchronized to wclk

	// Write and read enable signals for the RAM
	wire wenc, renc;

	// Flags for FIFO full and empty
	assign wfull = (wptr_gray == {~rptr_syn_wclk[ADDR_WIDTH:ADDR_WIDTH-1], rptr_syn_wclk[ADDR_WIDTH-2:0]});
	assign rempty = (rptr_gray == wptr_syn_rclk);

	// Dual-port RAM instantiation
	dual_port_RAM #(
		.DEPTH(DEPTH),
		.WIDTH(WIDTH)
	) fifo_mem (
		.wclk(wclk),
		.wenc(wenc),
		.waddr(wptr_bin[ADDR_WIDTH-1:0]),
		.wdata(wdata),
		.rclk(rclk),
		.renc(renc),
		.raddr(rptr_bin[ADDR_WIDTH-1:0]),
		.rdata(rdata)
	);

	// Write Enable Logic
	assign wenc = winc & ~wfull;

	// Read Enable Logic
	assign renc = rinc & ~rempty;

	// Write Pointer Logic
	always @(posedge wclk or negedge wrstn) begin
		if (!wrstn) begin
			wptr_bin <= 0;
			wptr_gray <= 0;
		end else if (wenc) begin
			wptr_bin <= wptr_bin + 1;
			wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);  // Binary-to-Gray Conversion
		end
	end

	// Read Pointer Logic
	always @(posedge rclk or negedge rrstn) begin
		if (!rrstn) begin
			rptr_bin <= 0;
			rptr_gray <= 0;
		end else if (renc) begin
			rptr_bin <= rptr_bin + 1;
			rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);  // Binary-to-Gray Conversion
		end
	end

	// Synchronize Read Pointer into Write Clock Domain
	always @(posedge wclk or negedge wrstn) begin
		if (!wrstn) begin
			rptr_syn_wclk <= 0;
		end else begin
			rptr_syn_wclk <= {rptr_syn_wclk[ADDR_WIDTH:0], rptr_gray};
		end
	end

	// Synchronize Write Pointer into Read Clock Domain
	always @(posedge rclk or negedge rrstn) begin
		if (!rrstn) begin
			wptr_syn_rclk <= 0;
		end else begin
			wptr_syn_rclk <= {wptr_syn_rclk[ADDR_WIDTH:0], wptr_gray};
		end
	end
endmodule

// Dual Port RAM Module
module dual_port_RAM#(
	parameter DEPTH = 16,
	parameter WIDTH = 8
)(
	input                  wclk,    // Write Clock
	input                  wenc,    // Write Enable
	input  [$clog2(DEPTH)-1:0] waddr,  // Write Address
	input      [WIDTH-1:0] wdata,   // Write Data
	input                  rclk,    // Read Clock
	input                  renc,    // Read Enable
	input  [$clog2(DEPTH)-1:0] raddr,  // Read Address
	output reg [WIDTH-1:0] rdata    // Read Data
);

	reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

	// Write Operation
	always @(posedge wclk) begin
		if (wenc) begin
			RAM_MEM[waddr] <= wdata;
		end
	end

	// Read Operation
	always @(posedge rclk) begin
		if (renc) begin
			rdata <= RAM_MEM[raddr];
		end
	end
endmodule