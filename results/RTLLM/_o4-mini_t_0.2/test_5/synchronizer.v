module synchronizer(
    input               clk_a,      // Clock domain A
    input               clk_b,      // Clock domain B
    input               arstn,      // Active‐low reset in A domain
    input               brstn,      // Active‐low reset in B domain
    input       [3:0]   data_in,    // 4‐bit data in A domain
    input               data_en,    // Enable in A domain
    output reg  [3:0]   dataout     // 4‐bit data out in B domain
);

    //-------------------------------------------------------------------------
    // A‐domain registers
    //-------------------------------------------------------------------------
    reg [3:0] data_reg;        // holds sampled data_in
    reg       en_data_reg;     // holds sampled data_en
    
    // Sample data_in and data_en in clk_a domain
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'd0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    //-------------------------------------------------------------------------
    // B‐domain enable synchronizer (2‐stage)
    //-------------------------------------------------------------------------
    reg en_clap_one, en_clap_two;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            // Two‐stage synchronization of en_data_reg into clk_b domain
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    //-------------------------------------------------------------------------
    // B‐domain output MUX
    //-------------------------------------------------------------------------
    // When en_clap_two is asserted, capture the A‐domain data_reg;
    // otherwise hold the previous dataout.
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else begin
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule