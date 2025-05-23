module dual_port_ram (
	input clk,
	input rst_n,
	 
	input write_en,
	input [7:0]write_addr,
	input [5:0]write_data,
	 
	input read_en,
	input [7:0]read_addr,
	output reg [5:0]read_data
);
	 // RAM port declaration
	 reg[63:0] RAM [63:1];
	 // write address register
	 wire wr;
	 assign wr = write_en && (write_addr == 1'b111_1111);
	 always @(posedge clk, negedge rst_n) begin
	 if(!rst_n)
	 RAM[0]<=0; // clear the register
	 else
	 RAM[0]<=RAM[0]; // copy content of 1'st register to next
	 end
	 assign write_data=RAM[wr];
	 
	 // read address and data registers
	 wire rd;
	 assign rd = read_en && (read_addr == 8'b0000000);
	 always @(posedge clk, negedge rst_n) begin
	 if(!rst_n)
	 read_data<=0; // zero register
	 else
	 read_data<=RAM[rd]; // copy content of 1'st register to next
	 end
endmodule