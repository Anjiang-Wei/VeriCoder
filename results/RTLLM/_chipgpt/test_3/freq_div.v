module freq_div (
	input clk_i,rst_n,
	output reg clk_2x,clk_10,clk_1
    );
	 
	 localparam N=5; //logical binary number of the frequency divider(5=2^3=8)
	 
	 reg[N:0] cnt_n=0; //counter for frequency dividing by 2^N
	 reg[4:0] cnt_10=0; //counter for frequency dividing by 10
	 reg clk_1=1'b0; //active low 
	 
	 //use the counter to divide the input clk by 2^(logical binary number of the freq divider)
	 always @(posedge clk_i or negedge rst_n ) begin
		if(!rst_n) cnt_n<=0;
		else if(clk_1 || clk_2x) cnt_n<cnt_n+1;
	 end
	assign clk_2x=!cnt_n; //active low 
	
	 //use the counter to divide the input clk by 10
	 always @(posedge clk_i or negedge rst_n ) begin
		if(!rst_n) cnt_10<=0;
		else if(clk_1 || clk_2x) cnt_10<cnt_10+1;
	 end
	assign clk_10=!cnt_10; //active low 
	assign clk_50=!cnt_n; //active high
	 
endmodule