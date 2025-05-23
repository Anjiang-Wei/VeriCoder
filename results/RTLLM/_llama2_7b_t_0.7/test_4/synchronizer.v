module synchronizer (
    input   clk_a,     // Clock signal A
    input   clk_b,     // Clock signal B
    input  arstn,        // Active-low reset signal A
    input  brstn,       // Active-low reset signal B
    input [3:0] data_in,  // Input data signal of size 4 bits
    input         data_en, // Input enable signal that controls the selection operation
    output reg [3:0] dataout // Output data signal of size 4 bits
);

// Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg <= 0;
    end else begin
        data_reg <= data_in;
    end
end

// Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        en_data_reg <= 0;
    end else begin
        en_data_reg <= data_en;
    end
end

// Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 0;
        en_clap_two <= 0;
    end else begin
        if (en_data_reg) begin
            en_clap_one <= en_clap_one;
            en_clap_two <= data_en;
        end else begin
            en_clap_one <= en_clap_one;
            en_clap_two <= en_clap_two;
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
        end else begin
            dataout <= dataout;
        end
    end
end