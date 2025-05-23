module synchronizer(
    input               clk_a, 
    input               clk_b,   
    input               arstn,
    input               brstn,
    input       [3:0]  data_in,
    input               data_en,

    output reg  [3:0]  dataout
);

    // Registers for data and enable signals
    reg [3:0] data_reg;
    reg data_en_reg;
    
    // Registers for enabling control, synchronized to clk_b
    reg en_clap_one;
    reg en_clap_two;

    // Data Register: Update on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0000; // Reset condition
        else
            data_reg <= data_in;  // Update with input data
    end

    // Enable Data Register: Update on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_en_reg <= 1'b0; // Reset condition
        else
            data_en_reg <= data_en; // Update with input enable signal
    end

    // Enable Control Registers: Update on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0; // Reset condition
            en_clap_two <= 1'b0; // Reset condition
        end else begin
            en_clap_one <= data_en_reg; // Assign current enable signal
            en_clap_two <= en_clap_one;  // Assign previous value of en_clap_one
        end
    end

    // Output Assignment: Update on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0000; // Reset condition
        end else if (en_clap_two) begin
            dataout <= data_reg; // Assign value from data register if enabled
        end // else retains previous dataout value
    end

endmodule