module synchronizer(
    input                clk_a   , 
    input                clk_b   ,   
    input                arstn   ,
    input                brstn   ,
    input        [3:0]   data_in ,
    input                data_en ,

    output reg   [3:0]   dataout
);

    // Internal registers
    reg [3:0] data_reg;          // To store the input data in clk_a domain
    reg       en_data_reg;       // To synchronize the data_en signal into clk_a domain
    reg       en_clap_one;       // First stage of sync register in clk_b domain
    reg       en_clap_two;       // Second stage of sync register in clk_b domain

    // Register in clk_a domain to capture data_in and data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;         // Reset data register to 0
            en_data_reg <= 1'b0;         // Reset enable data register to 0
        end else begin
            if (data_en) begin
                data_reg    <= data_in; // Capture data_in when data_en is high
            end
            en_data_reg <= data_en;      // Capture data_en
        end
    end

    // Two-stage synchronizer for en_data_reg in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;         // Reset first stage of synchronizer
            en_clap_two <= 1'b0;         // Reset second stage of synchronizer
        end else begin
            en_clap_one <= en_data_reg;  // Capture en_data_reg in first stage
            en_clap_two <= en_clap_one;  // Pass first stage value to second stage
        end
    end

    // Data output logic in clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;             // Reset output data to 0
        end else begin
            if (en_clap_two) begin
                dataout <= data_reg;     // Update output data when en_clap_two is high
            end else begin
                dataout <= dataout;      // Retain previous output data if en_clap_two is low
            end
        end
    end

endmodule