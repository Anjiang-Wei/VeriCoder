module serial2parallel ( 
	input clk,rst_n,
	input din_serial,din_valid, //8 bit input signal
	output reg[7:0]dout_parallel,
	output reg dout_valid
    );

//use counter to know how many bits of the serial input is left
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin  //load din with valid value for 4 cycles so it will wait until all 8 bits are received before moving to dout
		dout_valid <= 0;
		dout_parallel[7:0] <= 0;
    end
	else if(din_valid && !din_serial) begin //move the bit from din_serial to dout when the 8th bit is received
		dout_valid <= 1;
		dout_parallel[7:0] <= din_serial[7:0];
    end
	else if(din_valid && din_serial) begin //move the bit from din_serial to dout when the 8th bit is received
		dout_valid <= 1;
		dout_parallel[7:0] <= din_serial[7:0];
    end
end
endmodule