module synchronizer(
    input 				clk_a, 
    input 				clk_b,   
    input 				arstn,
    input				brstn   ,
    input		[3:0]	data_in	,
    input               data_en ,

    output reg  [3:0] 	dataout
);

// Data Register
reg [3:0] data_reg;
assign dataout = data_reg;

always @(posedge clk_a or negedge arstn)
begin
    if (!arstn) // Reset condition
        data_reg <= 'd0;
    else
        data_reg <= data_in;
end

// Enable Data Register
reg en_data_reg;
always @(posedge clk_a or negedge arstn)
begin
    if (!arstn) // Reset condition
        en_data_reg <= 'd0;
    else
        en_data_reg <= data_en;
end

// Enable Control Registers
reg [1:0] en_clap_one;
reg [1:0] en_clap_two;

always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) // Reset condition
        en_clap_one <= 'd0;
        en_clap_two <= 'd0;
    else
    begin
        en_clap_one <= {en_data_reg, 1'b0};
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) // Reset condition
        dataout <= 'd0;
    else if (en_clap_two == 2'b01) // en_clap_two is active
        dataout <= data_reg;
end

endmodule