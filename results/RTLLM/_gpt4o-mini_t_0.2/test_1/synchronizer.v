module synchronizer(
    input                clk_a, 
    input                clk_b,   
    input                arstn,
    input                brstn,
    input       [3:0]   data_in,
    input                data_en,
    
    output reg  [3:0]   dataout
);

// Registers to hold the data and enable signals
reg [3:0] data_reg;
reg data_en_reg;
reg en_clap_one, en_clap_two;

// Data Register - Updates on clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_reg <= 4'b0; // Reset data register
    else
        data_reg <= data_in; // Capture data input
end

// Enable Data Register - Updates on clk_a
always @(posedge clk_a or negedge arstn) begin
    if (!arstn)
        data_en_reg <= 1'b0; // Reset enable register
    else
        data_en_reg <= data_en; // Capture enable input
end

// Enable Control Registers - Updates on clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0; // Reset the first enable flip-flop
        en_clap_two <= 1'b0; // Reset the second enable flip-flop
    end else begin
        en_clap_one <= data_en_reg; // Capture enable signal from clk_a domain
        en_clap_two <= en_clap_one; // Delay enable signal for two clk_b cycles
    end
end

// Output Assignment - Updating dataout on clk_b
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0; // Reset output data
    end else begin
        if (en_clap_two)
            dataout <= data_reg; // Update output data if enable signal is valid
        // else keep the previous value of dataout
    end
end

endmodule