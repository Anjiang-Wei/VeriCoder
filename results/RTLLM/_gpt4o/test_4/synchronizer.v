module synchronizer(
	input               clk_a   , 
	input               clk_b   ,   
	input               arstn   ,
	input               brstn   ,
	input       [3:0]   data_in ,
	input               data_en ,

	output reg  [3:0]   dataout
);

    // Registers for intermediate storage and synchronization
    reg [3:0] data_reg;       // Register to capture `data_in` in clk_a domain
    reg       en_data_reg;    // Register to capture `data_en` in clk_a domain
    reg       en_clap_one;    // First stage enable synchronizer (clk_b domain)
    reg       en_clap_two;    // Second stage enable synchronizer (clk_b domain)

    // Capture `data_in` and `data_en` in the clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;   // Reset data_reg to 0
            en_data_reg <= 1'b0;   // Reset en_data_reg to 0
        end else begin
            data_reg    <= data_in;    // Capture input data
            en_data_reg <= data_en;    // Capture enable signal
        end
    end

    // Double-sync `data_en` in the clk_b domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;   // Reset first-stage synchronizer
            en_clap_two <= 1'b0;   // Reset second-stage synchronizer
        end else begin
            en_clap_one <= en_data_reg;   // First stage captures `en_data_reg`
            en_clap_two <= en_clap_one;  // Second stage captures `en_clap_one`
        end
    end

    // Output logic: Transfer data to `dataout` if en_clap_two is active
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;   // Reset output to 0
        end else if (en_clap_two) begin
            dataout <= data_reg;    // Synchronize data to clk_b domain
        end else begin
            dataout <= dataout;     // Hold previous data
        end
    end

endmodule