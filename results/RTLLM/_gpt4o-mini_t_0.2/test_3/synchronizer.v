module synchronizer(
    input               clk_a, 
    input               clk_b,   
    input               arstn,
    input               brstn,
    input       [3:0]  data_in,
    input               data_en,
    output reg  [3:0]  dataout
);

// Data register to store input data
reg [3:0] data_reg;

// Enable data register to store input enable signal
reg en_data_reg;

// Registers to synchronize the enable signal across clk_b
reg en_clap_one;
reg en_clap_two;

// On positive edge of clk_a, update data_reg and en_data_reg
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg <= data_in;
        en_data_reg <= data_en;
    end
end

// On positive edge of clk_b, update en_clap_one and en_clap_two
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one; // Delay by one clock cycle
    end
end

// Assign output based on clk_b and enable signals
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else if (en_clap_two) begin
        dataout <= data_reg; // Update dataout with data_reg when enabled
    end
    // If en_clap_two is not active, dataout retains its previous value
end

endmodule