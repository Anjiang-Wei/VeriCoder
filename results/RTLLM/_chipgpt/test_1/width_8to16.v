module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);
    //registers
    reg [7:0] data_lock;
    reg [7:0] data_in_pending;
    reg [15:0] data_out_reg;
    
    //input signal declarations for next-clock cycle operation
    assign {valid_out,data_out} = valid_in && (data_lock == 0 || data_in == data_in_pending);
    
    always @(posedge clk or negedge rst_n) begin   //registers
        if(!rst_n)         data_lock <= 0;   //initialization
        else if (valid_in) data_lock <= data_in; 
    end    
    
    always @(posedge clk or negedge rst_n) begin   //registers
        if(!rst_n)         data_in_pending <= 0;   //initialization
        else if (valid_in) data_in_pending <= data_in; 
    end    

    always @* begin //output
      if (!rst_n && !data_lock) data_out_reg = 0; //initialization
      
      else if(data_lock && data_in_pending == data_in) begin   //concatenate registers to form the output data
		   data_out_reg = {data_lock,data_in_pending};
		 end 
    end
assign valid_out = data_lock?1:0;
assign data_out = data_out_reg;

endmodule