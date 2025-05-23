module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
    );  //output the parallel data when all 8 serial input bits are received.
	 wire[3:0]cnt;//counter that counts up to 8 and then wraps back to zero. When it wraps back to zero, dout_valid becomes 1 which indicates that the parallel output is valid.
	 reg done=0; //signal that indicates counter has reached its maximum number(8) 
	 wire[3:0]cnt_en;//counter ena signal that controls if cnt should wrap back to zero or not
	 wire dout_serial; //output of the counter that counts up to 8 and then wraps back to zero. When it wraps back to zero,dout_valid becomes 1 which indicates that the parallel output data is valid
	 serial2parallel m0(clk,rst_n,din_serial,din_valid,{cnt[3:0]},cnt_en,dout_serial); //The 4-bit counter used to count up to 8. When it wraps back to zero, din_valid will be set to 1 indicating that the parallel output data is valid.
	 parallel_counter m1(clk,rst_n,done,{cnt_en},dout_serial); //The 4-bit counter used to count up to 8. When it wraps back to zero, din_valid will be set to 1 indicating that the parallel output data is valid
	 assign dout_parallel=(~dout_serial)?8'hff: {dout_serial[7:0]}; //dout_serial is the 4-bit counter that keeps track of how many din_serial bits are received. When all 8 serial bits are received, it will be set to 1 which indicates that dout_valid becomes 1 indicating that the parallel output data is valid
	 assign cnt[3:0]=din_serial;//counter counts up to 8 and then wraps back to zero. When it wraps back to zero,dout_valid becomes 1 indicating that the parallel output data is valid.
endmodule