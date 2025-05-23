module top(
	input               clk         ,   
	input               rst_n       ,
	input                in          ,
	output              out
); 
	 wire                valid_in     ; // input signal indicating readiness for new data
	 reg                 datain       ;
	 wire [9:0]   data_out      ; 
	 assign out         = (datain==4'd1) ? in : (data_out == {9{1'b0}})? in : (data_out == {9{1'b1}}) ? in : (data_out == {9{1'b1}}) ? in : datain;

	 accu 
	(
	.clk      ,
	.rst_n   ,
	.data_in ,
	.valid_in, 
	.valid_out,
	.data_out, 
    );
endmodule