module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

// Data Register
reg [3:0] data_reg;

always @(posedge clk_a or negedge arstn)
if (!arstn) 
    data_reg <= 'd0;
else
    data_reg <= data_in;

// Enable Data Register
reg en_data_reg;

always @(posedge clk_a or negedge arstn)
if (!arstn) 
    en_data_reg <= 1'b0;
else
    en_data_reg <= data_en;

// Enable Control Registers
reg [2:0] en_clap_one, en_clap_two;

always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) 
        begin
            en_clap_one <= 'd0;
            en_clap_two <= 'd0;
        end
    else
        begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
end

// Output Assignment
always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) 
        dataout <= 'd0;
    else
        begin
            case (en_clap_two)
                3'b000 : dataout <= data_reg;  // Not using en_data_reg as it's delayed by two cycles
                default: dataout <= dataout;
            endcase
        end
end

endmodule