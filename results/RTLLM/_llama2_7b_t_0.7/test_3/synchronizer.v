module synchronizer(
    input  clk_a,
    input  clk_b,
    input  arstn,
    input  brstn,
    input [3:0] data_in,
    input   data_en,
    output reg [3:0] dataout
);

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 0;
    end else begin
        if (data_en) begin
            data_reg <= data_in;
        end
    end
end

// Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 0;
    end else begin
        if (data_en) begin
            en_data_reg <= data_en;
        end
    end
end

// Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0;
        en_clap_two <= 0;
    end else begin
        if (en_data_reg) begin
            en_clap_one <= data_reg;
            en_clap_two <= en_clap_one;
        end
    end
end

// Output Assignment
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 0;
    end else begin
        if (en_clap_two) begin
            dataout <= data_reg;
        end
    end
end