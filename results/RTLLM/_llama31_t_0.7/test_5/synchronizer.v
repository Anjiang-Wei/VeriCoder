module synchronizer(
    input              clk_a     , // Clock signal A used for synchronous operations.
    input              clk_b     , // Clock signal B used for synchronous operations.
    input              arstn     , // Active-low reset signal A. Defined as 0 for reset and 1 for reset signal inactive.
    input              brstn     , // Active-low reset signal B. Defined as 0 for reset and 1 for reset signal inactive.
    input      [3:0]   data_in   , // Input data signal of size 4 bits.
    input               data_en  , // Input enable signal that controls the selection operation.

    output reg  [3:0] 	dataout // Output data signal of size 4 bits.
);

// Data Register
reg  [3:0]  data_reg;

always @(posedge clk_a or negedge arstn)
begin
    if (!arstn) // Reset condition, set register to 0
        data_reg <= '0;
    else
        data_reg <= data_in; // Update register with input data signal
end

// Enable Data Register
reg               en_data_reg;

always @(posedge clk_a or negedge arstn)
begin
    if (!arstn) // Reset condition, set enable register to 0
        en_data_reg <= '0;
    else
        en_data_reg <= data_en; // Update enable register with input enable signal
end

// Enable Control Registers
reg               en_clap_one;
reg               en_clap_two;

always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) // Reset condition, set control registers to 0
        begin
            en_clap_one <= '0;
            en_clap_two <= '0;
        end
    else
        begin
            en_clap_one <= en_data_reg; // Update register one with enable data register value
            en_clap_two <= en_clap_one; // Update register two with previous value of register one
        end
end

// Output Assignment
always @(posedge clk_b or negedge brstn)
begin
    if (!brstn) // Reset condition, set output to 0
        dataout <= '0;
    else
        begin
            if (en_clap_two) // Control signal is active
                dataout <= data_reg; // Assign output with value from data register
            end
end

endmodule