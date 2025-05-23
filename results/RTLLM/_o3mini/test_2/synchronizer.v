module synchronizer(
    input               clk_a   , 
    input               clk_b   ,   
    input               arstn   ,
    input               brstn   ,
    input       [3:0]   data_in ,
    input               data_en ,

    output reg  [3:0]   dataout
);

    // Internal registers:
    // data_reg: Captures the input data from clk_a domain.
    // en_data_reg: Captures the input enable signal from clk_a domain.
    reg [3:0] data_reg;
    reg       en_data_reg;

    // Control registers to synchronize the enable signal into the clk_b domain.
    // en_clap_one and en_clap_two are cascaded D flip-flops to avoid metastability.
    reg en_clap_one;
    reg en_clap_two;

    //===============================================
    // Data Register and Enable Data Register (Clock A)
    //===============================================
    // data_reg and en_data_reg are updated on the positive edge of clk_a.
    // They are asynchronously reset on the falling edge of arstn.
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    //===============================================
    // Enable Control Registers (Clock B)
    // ==============================================
    // These registers delay the enable signal (en_data_reg) by two clk_b cycles.
    // This double synchronization is performed on the clk_b domain and use asynchronous reset brstn.
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    //===============================================
    // Output Data Assignment (Clock B)
    //===============================================
    // The output dataout is updated on the clk_b domain when en_clap_two is active.
    // If en_clap_two is not active, dataout holds its previous value.
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn)
            dataout <= 4'b0;
        else begin
            if (en_clap_two)
                dataout <= data_reg;
            // else retains previous value
        end
    end

endmodule