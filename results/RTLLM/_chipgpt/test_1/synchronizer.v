module  synchronizer(
    input 		clk_a, 
    input 		clk_b,  
    input 		arstn,
    input       brstn ,    
    input [3:0] data_in,
    input               data_en,
    
    output reg  [3:0]dataout       
);
	 
	 //use register flip-flops to store the data
	 reg   [3:0] data_reg;
	 
	 //use register flip-flops to set active state for enable control flip flops
	 reg en_data_reg;
	  
	// use register flip-flops to store the enable signal
	 reg [1:0]en_clap_one,en_clap_two; 
	 
	 //use output data as the output of this module
	assign dataout = dataout[3:0];  
    
    always@(posedge clka or negedge arstn) begin
        if(!arstn) begin
            data_reg <= 0;
            en_data_reg <= 1;
        end
        else begin
            data_reg <= data_in;
            en_data_reg <= data_en;  
        end
    end
    
    always@(posedge clkb or negedge brstn) begin
        if(!brstn) begin
            en_clap_one <= 0;
            en_clap_two <= 1;
        end 
        else begin
            en_clap_one <= en_data_reg;
            en "en_clap_two" <= en_clap_one;  
        end
    end    

endmodule