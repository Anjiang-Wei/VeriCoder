module synchronizer(
    input               clk_a   ,   // Clock A
    input               clk_b   ,   // Clock B
    input               arstn   ,   // Active-low reset for Clock A domain
    input               brstn   ,   // Active-low reset for Clock B domain
    input       [3:0]   data_in ,   // 4-bit input data, clocked in Clock A domain
    input               data_en ,   // Enable signal, clocked in Clock A domain
    
    output reg  [3:0]   dataout      // 4-bit output synchronized to Clock B domain
);

    // Register to store the input data in Clock A domain
    reg [3:0] data_reg;
    
    // Register to synchronize data_en signal in Clock A domain
    reg en_data_reg;

    // Registers to synchronize enable signal into Clock B domain 
    reg en_clap_one, en_clap_two;

    // Synchronize data_in and data_en in Clock A domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            // Reset logic
            data_reg <= 4'b0;      // Clear the stored input data
            en_data_reg <= 1'b0;   // Clear the synchronized enable
        end else begin
            // Capture data_in and data_en
            if (data_en) begin
                data_reg <= data_in;  // Store input data when data_en is high
            end
            en_data_reg <= data_en;   // Synchronize data enable signal
        end
    end

    // Synchronize the enable signal into Clock B domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            // Reset logic for enable registers in Clock B domain
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;   // First stage of enable signal synchronization
            en_clap_two <= en_clap_one;  // Second stage of enable signal synchronization
        end
    end

    // Output data logic in Clock B domain
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            // Reset logic for output data
            dataout <= 4'b0;
        end else if (en_clap_two) begin
            // Only update output when enable signal is active
            dataout <= data_reg;
        end
        // If en_clap_two is not set, output retains its previous value
    end

endmodule