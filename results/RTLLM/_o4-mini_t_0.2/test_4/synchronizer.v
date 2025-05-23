module synchronizer(
    input           clk_a,      // Source domain clock
    input           clk_b,      // Destination domain clock
    input           arstn,      // Active‑low reset for clk_a domain
    input           brstn,      // Active‑low reset for clk_b domain
    input   [3:0]   data_in,    // 4‑bit data in clk_a domain
    input           data_en,    // Enable in clk_a domain
    output reg [3:0] dataout    // 4‑bit data in clk_b domain
);

    //========================================================================
    // clk_a domain
    //   - data_reg      holds data_in
    //   - en_data_reg   holds data_en
    //========================================================================
    reg [3:0] data_reg;
    reg       en_data_reg;

    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg    <= 4'b0;
            en_data_reg <= 1'b0;
        end else begin
            data_reg    <= data_in;
            en_data_reg <= data_en;
        end
    end

    //========================================================================
    // clk_b domain
    //   - Two‑stage synchronizer for the enable
    //   - MUX of data_reg into dataout when en_clap_two is asserted
    //========================================================================
    reg en_clap_one, en_clap_two;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'b0;
        end else begin
            // two‑stage synchronizer for the enable signal
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;

            // when the delayed enable (en_clap_two) is high,
            // latch data_reg into dataout; otherwise hold
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule