module synchronizer(
    input 				clk_a, 
    input 				clk_b,  
    input 				arstn, 
    input				brstn,  
    input		[3:0]	data_in, 
    input               data_en, 
    output reg [3:0] 	dataout
);

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 0; // Reset data register on reset
    end else begin
        data_reg <= data_in; // Update data register on positive edge of clock A
    end
end

// Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 0; // Reset enable data register on reset
    end else begin
        en_data_reg <= data_en; // Update enable data register on positive edge of clock A
    end
end

// Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0; // Reset enable control register on reset
        en_clap_two <= 0; // Reset enable control register on reset
    end else begin
        en_clap_one <= en_data_reg; // Update enable control register on positive edge of clock B
        en_clap_two <= en_clap_one; // Update enable control register on positive edge of clock B
    end
end

// Output Assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 0; // Reset output on reset
    end else begin
        dataout <= data_reg; // Assign output value based on data register
    end
end