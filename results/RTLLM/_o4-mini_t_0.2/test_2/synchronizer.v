module synchronizer(
    input             clk_a,     // source clock domain
    input             clk_b,     // destination clock domain
    input             arstn,     // async active‑low reset for clk_a domain
    input             brstn,     // async active‑low reset for clk_b domain
    input   [3:0]     data_in,   // 4‑bit source data
    input             data_en,   // source enable
    output reg [3:0]  dataout    // synchronized 4‑bit output
);

    // ----------------------------------------------------------------
    // 1) Registers in clk_a domain
    //    - data_reg     : captures data_in
    //    - en_data_reg  : captures data_en
    // ----------------------------------------------------------------
    reg  [3:0] data_reg;
    reg        en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg     <= 4'd0;
            en_data_reg  <= 1'b0;
        end else begin
            data_reg     <= data_in;
            en_data_reg  <= data_en;
        end
    end

    // ----------------------------------------------------------------
    // 2) Two‐stage synchronizer for the enable in clk_b domain
    //    - en_clap_one : first stage
    //    - en_clap_two : second stage
    //
    // 3) When en_clap_two goes high, latch data_reg into dataout
    //    on clk_b.  Otherwise hold previous dataout.
    // ----------------------------------------------------------------
    reg en_clap_one, en_clap_two;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            // Synchronize enable
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            // When the second‑stage enable is high, update dataout
            if (en_clap_two) begin
                dataout <= data_reg;
            end
            // else dataout holds its value
        end
    end

endmodule