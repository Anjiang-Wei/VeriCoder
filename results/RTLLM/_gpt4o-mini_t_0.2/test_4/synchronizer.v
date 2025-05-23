module synchronizer(
    input               clk_a, 
    input               clk_b,   
    input               arstn,
    input               brstn,
    input       [3:0]   data_in,
    input               data_en,
    output reg  [3:0]   dataout
);

// Data register to store data_in
reg [3:0] data_reg;

// Enable data register to store data_en
reg en_data_reg;

// Enable control registers for data synchronization
reg en_clap_one;
reg en_clap_two;

// Always block to update data_reg on clock A
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 4'b0000;  // Reset data register on arstn
    end else begin
        data_reg <= data_in;  // Update data register on clk_a
    end
end

// Always block to update en_data_reg on clock A
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 1'b0;  // Reset enable register on arstn
    end else begin
        en_data_reg <= data_en; // Update enable register on clk_a
    end
end

// Always block to update enable control registers on clock B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;  // Reset first enable control register on brstn
        en_clap_two <= 1'b0;  // Reset second enable control register on brstn
    end else begin
        en_clap_one <= en_data_reg;                // Update first enable control register
        en_clap_two <= en_clap_one;                 // Update second enable control register
    end
end

// Always block to assign dataout on clock B
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0000;  // Reset output data on brstn
    end else if (en_clap_two) begin
        dataout <= data_reg;  // Assign data_reg to dataout if en_clap_two is high
    end else begin
        dataout <= dataout;   // Retain previous value of dataout otherwise
    end
end

endmodule