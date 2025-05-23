module synchronizer(
    input               clk_a,       // Clock A
    input               clk_b,       // Clock B
    input               arstn,       // Active-low reset for clock A
    input               brstn,       // Active-low reset for clock B
    input       [3:0]   data_in,     // 4-bit input data
    input               data_en,     // Enable signal

    output reg  [3:0]   dataout      // 4-bit output data
);

// Register to store input data referenced to clk_a
reg [3:0] data_reg;

// Register to store enable signal referenced to clk_a
reg en_data_reg;

// Enable registers synchronized to clk_b
reg en_clap_one;
reg en_clap_two;

// Data Register: Capture data_in when clk_a's enable signal is active
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'b0; // Reset condition
    else if (data_en)
        data_reg <= data_in; // Capture data_in when data_en is high
end

// Enable Data Register: Capture data_en at clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        en_data_reg <= 1'b0; // Reset condition
    else
        en_data_reg <= data_en; // Capture data_en for synchronization
end

// Synchronize Enable Signal to clk_b: 2-stage flip-flops
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0; // Reset condition
        en_clap_two <= 1'b0; // Reset condition
    end else begin
        en_clap_one <= en_data_reg; // First stage
        en_clap_two <= en_clap_one; // Second stage
    end
end

// Output Logic: Update dataout based on synchronized enable signal en_clap_two
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0; // Reset condition
    else if (en_clap_two) 
        dataout <= data_reg; // Output data when enable signal is valid
    else
        dataout <= dataout; // Maintain output value when enable signal is invalid
end

endmodule