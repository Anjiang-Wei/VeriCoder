module synchronizer(
    input               clk_a,      // Clock domain A
    input               clk_b,      // Clock domain B
    input               arstn,      // async reset, active low, for clk_a domain
    input               brstn,      // async reset, active low, for clk_b domain
    input       [3:0]   data_in,    // 4‐bit data in, synchronous to clk_a
    input               data_en,    // data‐enable, synchronous to clk_a
    output reg  [3:0]   dataout     // 4‐bit data out, synchronous to clk_b
);

    // capture data_in and data_en in clk_a domain
    reg [3:0] data_reg;
    reg       en_data_reg;
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg     <= 4'd0;
            en_data_reg  <= 1'b0;
        end else begin
            data_reg     <= data_in;
            en_data_reg  <= data_en;
        end
    end

    // two‐stage synchronizer for the enable signal into clk_b domain
    reg en_clap_one, en_clap_two;
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_clap_one <= 1'b0;
            en_clap_two <= 1'b0;
        end else begin
            en_clap_one <= en_data_reg;
            en_clap_two <= en_clap_one;
        end
    end

    // when the two‐stage synchronized enable goes high, sample data_reg into dataout
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'd0;
        end else if (en_clap_two) begin
            dataout <= data_reg;
        end else begin
            // hold previous value
            dataout <= dataout;
        end
    end

endmodule