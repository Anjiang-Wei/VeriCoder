module synchronizer(
    input            clk_a,     // clock domain A
    input            clk_b,     // clock domain B
    input            arstn,     // async active‑low reset for clk_a domain
    input            brstn,     // async active‑low reset for clk_b domain
    input  [3:0]     data_in,   // 4‑bit source data in clk_a domain
    input            data_en,   // enable in clk_a domain
    output reg [3:0] dataout    // 4‑bit synchronized output in clk_b domain
);

    //==========================================================================
    // Domain A registers: sample data_in and data_en in clk_a domain
    //==========================================================================
    reg [3:0] data_reg;
    reg       en_data_reg;

    // sample data_in
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) 
            data_reg <= 4'd0;
        else 
            data_reg <= data_in;
    end

    // sample data_en
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn)
            en_data_reg <= 1'b0;
        else
            en_data_reg <= data_en;
    end


    //==========================================================================
    // Domain B registers: two‐stage synchronizer for en_data_reg, plus dataout
    //==========================================================================
    reg en_clap_one;
    reg en_clap_two;

    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            // async reset in clk_b domain
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
            dataout     <= 4'd0;
        end else begin
            // synchronize the enable into clk_b
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
            // when synchronized enable is high, update dataout from data_reg;
            // otherwise hold previous value
            if (en_clap_two)
                dataout <= data_reg;
            else
                dataout <= dataout;
        end
    end

endmodule