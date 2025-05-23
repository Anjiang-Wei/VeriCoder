module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);
	 
	 // Counter to keep track of the number of din serial received. 8 din serial represent one parallel data
	 localparam[3:0] cnt_size = 4'b1000;
	 reg [3:0]cnt;
	 
	 //output wire for the counter
	 output reg[3:0]dout_counter;
	  
	 //wire for sync operation
	 wire synchrnz;
	 
	 //register file to store the parallel data. The register is 8 bit wide so when the counter reaches value of "cnt_size", it will output 8 bits(representing one parallel datum)
	 reg [7:0]dout_parallel_reg;   //8 bit register for storing one parallel datum
	 
	 //register file to store the status of the parallel data
	 reg[1:0]dout_valid_reg;     //2 bits register, "00" means that there are still 7 more din serials left and "01" means that all 8 din serial have been recieved

	 
	 //register file to store the count of the parallel data
	 reg[7:0]dout_counter_reg;   //8 bit register for storing the total count of the parallel data
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			cnt<=0;
		end
		else begin
			dout_counter<=dout_counter+1;
			dout_valid<=din_valid;   //output the current status of din valid
			if(dout_counter=={cnt_size{1'b0}} && din_valid) begin
				dout_valid <= 1'b1;
			end
			else if(!din_valid) begin   //do nothing when the input of din is invalid
				dout_valid<=0;
			end
		end
	 end
	 
	 always @* begin    //sync operation will only take place during rising edge
		synchrnz=1'b0;
		if(din_valid && ~dout_valid) synchrnz = din_valid;   //do nothing when the input of din is invalid
		else if(!dout_counter&&dout_valid&&!synchrnz) begin  //when the counter reaches value of "cnt_size" and the sync operation has not been made, it will output a logic high and signal for synchronous operation (synchrnz)
			dout_valid=1'b1;   //output the current status of din valid as one(for 8 bit data width), which means that there is still more data to be outputed, so do not stop here. Instead continue to wait for the next rising edge of clk and wait for the sync operation(synchrnz)
		end
		else if(!din_valid&&dout_counter&&!synchrnz) begin  //when the counter is greater than "cnt_size" and the sync operation has not been made, it will output a logic low. This indicates that all data have been received already so do not stop here
			dout_valid=1'b0;   //output the current status of din valid as zero
		end
	 end
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) dout_counter_reg<=0;
		else if(synchrnz) dout_counter_reg<=dout_counter;   //when the sync operation is made and din is valid, it will output the value of the counter which indicates how many parallel data have been received already. This signal will be used to store 8 bits into the register file "dout_parallel_reg".
	end
	 
	 always @(posedge clk,negedge rst_n) begin
		if(!rst_n) dout_parallel=0;   //start with all zeroes
		else if(synchrnz && din_valid) begin
			dout_parallel<=dout_counter_reg[7:0];  //store the value of counter into register file, which is equivalent to storing 8 bits of data. This will be used for next stage where it will output the parallel data in a synchronous way
		end
	 end
	 assign dout_valid_reg=dout_parallel[1];   //2 bits register(0x3) indicating that there are still 7 more data left and (0x1) indicating that all 8 din serials have been received. This signal will be used to output the parallel data in synchronous way
	 assign dout_parallel=dout_valid_reg? {din_serial,dout_counter_reg[7:0]} : dout_parallel;   //output the value of register file(which is equivalent to storing 8 bits of data) in a synchronous way when "dout_valid" is 1
	 assign dout_valid=dout_valid_reg?1'b1:1'b0;    //output the current status of din valid as one indicating that there are still more parallel data to be outputed or zero indicating that all 8 parallel data have been outputed. The signal "din_valid" will only start when this signal is 0.
	 
endmodule