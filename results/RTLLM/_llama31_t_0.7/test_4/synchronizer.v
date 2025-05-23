module synchronizer(
    input              clk_a,      // Clock signal A used for synchronous operations.
    input              clk_b,      // Clock signal B used for synchronous operations.
    input              arstn,      // Active-low reset signal A. Defined as 0 for reset and 1 for reset signal inactive.
    input              brstn,      // Active-low reset signal B. Defined as 0 for reset and 1 for reset signal inactive.
    input        [3:0] data_in,     // Input data signal of size 4 bits.
    input              data_en,    // Input enable signal that controls the selection operation.

    output reg         dataout      // Output data signal of size 4 bits.
);

// Local registers to store the input data and enable signals
reg [3:0] data_reg;
reg data_en_reg;
reg en_clap_one;
reg en_clap_two;

always @(posedge clk_a or negedge arstn) begin
    // Update data register on positive edge of clk_a or falling edge of arstn
    if (!arstn) begin
        data_reg <= 0;           // Reset to zero when arstn is low
    end else begin
        data_reg <= data_in;     // Update with new value when arstn is high
    end

    // Update enable register on positive edge of clk_a or falling edge of arstn
    if (!arstn) begin
        data_en_reg <= 0;        // Reset to zero when arstn is low
    end else begin
        data_en_reg <= data_en;   // Update with new value when arstn is high
    end
end

// Delayed enable signal using two D flip-flops
reg en_clap_one_dly;
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0;         // Reset to zero when brstn is low
        en_clap_two <= 0;         // Reset to zero when brstn is low
    end else begin
        en_clap_one <= data_en_reg;
        en_clap_two <= en_clap_one;
    end

    // Delayed enable signal using two D flip-flops
    if (!brstn) begin
        en_clap_one_dly <= 0;     // Reset to zero when brstn is low
    end else begin
        en_clap_one_dly <= en_clap_two;
    end
end

// Output assignment on positive edge of clk_b or falling edge of brstn
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 0;             // Reset to zero when brstn is low
    end else if (en_clap_one_dly) begin
        dataout <= data_reg;      // Assign output value when en_clap_one_dly is active
    end
end

endmodule