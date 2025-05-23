module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);
	 // declare the register
    localparam WIDTH=16'd4;
    reg [WIDTH-1:0] data_lock;
    reg [WIDTH-1:0] data_reg;
 
    //output signals for validity and output data
    always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
	begin
	data_lock<=0;
	data_reg <=0;
	valid_out<=1'b0;
	end

	else if(valid_in && !data_lock) begin //wait for the first valid input to be stored in the register
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	    valid_out<=1'b1;
	end
	else if(valid_in && data_lock) begin //wait for the second valid input to be stored in the register
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	    valid_out<=1'b1;
	end
	else if(valid_in && !data_lock) begin //wait for the second valid input to be stored in the register and then generate output signals
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
	else if(!valid_in && data_lock) begin //wait for the second valid input to be stored in the register
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
	else if(!valid_in && !data_lock) begin //wait for the second valid input to be stored in the register and then generate output signals
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
	else if(!valid_in && !data_lock) begin //wait for the second valid input to be stored in the register and then generate output signals
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
	else if(valid_in && !data_lock) begin //wait for the second valid input to be stored in the register and then generate output signals
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
	else if(!valid_in && !data_lock) begin //wait for the second valid input to be stored in the register and then generate output signals
	   data_lock<=data_in[7:0]; 
	    data_reg<=data_in;
	   valid_out<=1'b1;
	end
    end

	 assign data_out=data_reg;
	 always@(posedge clk or negedge rst_n) begin
	 if(!rst_n) 
	 begin
	 data_lock<=0;
	 data_reg<=0;
	 end
	 else if(!valid_in && !data_lock)
	 begin 
	 data_lock<=0;
	 data_reg<=0;
	 end
	 else if(valid_in && data_lock)
	 begin
	 data_lock<=data_in[7:0]; 
	 data_reg<=data_in;
	end
	end
	assign valid_out=!data_lock;

endmodule