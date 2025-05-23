module synchronizer(
    input               clk_a, 
    input               clk_b,   
    input               arstn,
    input               brstn,
    input       [3:0]   data_in,
    input               data_en,
    output reg  [3:0]   dataout
);

    // Register to store the input data signal
    reg [3:0] data_reg;
    // Register to store the enable signal
    reg data_en_reg;
    // Registers for synchronizing the enable signal on clk_b
    reg en_clap_one;
    reg en_clap_two;

    // Data Register update on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_reg <= 4'b0; // Reset data_reg
        else
            data_reg <= data_in; // Update with data_in when arstn is high
    end

    // Enable Data Register update on clk_a
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            data_en_reg <= 1'b0; // Reset data_en_reg
        else
            data_en_reg <= data_en; // Update with data_en when arstn is high
    end

    // Enable Control Registers update on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0; // Reset en_clap_one
            en_clap_two <= 1'b0; // Reset en_clap_two
        end else begin
            en_clap_one <= data_en_reg; // Sample the enable signal
            en_clap_two <= en_clap_one; // Propagate to the second flip-flop
        end
    end

    // Output assignment on clk_b
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) 
            dataout <= 4'b0; // Reset dataout
        else if (en_clap_two) 
            dataout <= data_reg; // Output data when en_clap_two is high
    end

endmodule