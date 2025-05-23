module synchronizer(
    input               clk_a,    // Clock A for capturing input data and enable signal
    input               clk_b,    // Clock B for synchronized output generation
    input               arstn,    // Active-low reset for clock domain A
    input               brstn,    // Active-low reset for clock domain B
    input       [3:0]   data_in,  // 4-bit input data
    input               data_en,  // Enable signal for data capture

    output reg  [3:0]   dataout   // 4-bit output data
);

// Registers in Clock Domain A
reg [3:0] data_reg;    // Holds the sampled data_in
reg       en_data_reg; // Holds the sampled data_en

// Synchronizer registers in Clock Domain B (2-stage synchronizer)
reg       en_clap_one;
reg       en_clap_two;

//
// Data Register and Enable Data Register (Clock Domain A)
// On the positive edge of clk_a or falling edge of arstn, capture data_in and data_en.
// When arstn is deasserted (low), initialize registers to 0.
//
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'b0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

//
// Enable Control Registers (Synchronizer: Clock Domain B)
// On the positive edge of clk_b or falling edge of brstn, delay the sampled enable signal 
// through two D flip-flops (en_clap_one and en_clap_two).
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

//
// Output Assignment (Clock Domain B)
// On the positive edge of clk_b or falling edge of brstn, if the delayed enable (en_clap_two)
// is active, update the output data from data_reg. Otherwise, hold the previous dataout.
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'b0;
    end else begin
        if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            dataout <= dataout; // Retain previous value if enable signal is inactive
        end
    end
end

endmodule