module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

// Internal registers and flip-flops
reg [3:0] data_reg;
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;

// Flip-flops for enabling data_en with a delay of two clock cycles
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 1'b0;
    end else begin
        en_data_reg <= data_en;
    end
end

// Registers for data_in and data_en with synchronous reset
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0;
    end else begin
        data_reg <= data_in;
    end
end

// Control registers for enabling data selection
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

// Output assignment with a delay of two clock cycles
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end
end

endmodule