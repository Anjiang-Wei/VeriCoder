module synchronizer (
    input   clk_a,
    input   clk_b,
    input   arstn,
    input   brstn,
    input [3:0] data_in,
    input  data_en,
    output reg [3:0] dataout
);

// Data Register
module data_reg (
    input  clk_a,
    input  arstn,
    input  en_data_reg,
    output reg [3:0] data_reg
);

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 0;
    end else if (en_data_reg) begin
        data_reg <= data_in;
    end
end

// Enable Data Register
module en_data_reg (
    input  clk_a,
    input  arstn,
    input  en_data_reg,
    output reg [3:0] en_data_reg
);

always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 0;
    end else if (en_data_reg) begin
        en_data_reg <= data_en;
    end
end

// Enable Control Registers
module en_clap_one (
    input  clk_b,
    input  brstn,
    output reg [3:0] en_clap_one
);

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0;
    end else begin
        en_clap_one <= en_data_reg;
    end
end

module en_clap_two (
    input  clk_b,
    input  brstn,
    output reg [3:0] en_clap_two
);

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_two <= 0;
    end else begin
        en_clap_two <= en_clap_one;
    end
end

// Output Assignment
module output_assign (
    input  clk_b,
    input  brstn,
    output reg [3:0] dataout
);

always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 0;
    end else begin
        dataout <= en_clap_two;
    end
end