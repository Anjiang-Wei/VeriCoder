module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input 			brstn   ,
	input [3:0] 		data_in	,
	input 				data_en ,
	output reg  [3:0] dataout
);
// register file with 8-bit data
always @(posedge clk_a or posedge arstn) begin
    if (arstn == 0)   // If reset is LOW then register value will be zero.
        dataout <= 0;
    else if ((data_en && brstn == 1))
        dataout <= datain;// when active-low, it is set to one and becomes zero otherwise. When the signal is inactive (brstn) then registers will remain as zero
    else
        dataout <= dataout; // if the enable is not activated but brstn is active(when high), this signal remains unchanged and no changes occur. 
end
endmodule