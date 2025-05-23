-- Control registers
reg en_data_reg;
reg en_clap_one;
reg en_clap_two;

-- Data Register
always @(posedge clk_a or negedge arstn) begin
    if(!arstn) begin
        data_reg <= 4'b0;
    end else begin
        data_reg <= data_in;
    end
end

-- Enable Data Register
always @(posedge clk_a or negedge arstn) begin
    if(!arstn) begin
        en_data_reg <= 1'b0;
    end else begin
        en_data_reg <= data_en;
    end
end

-- Enable Control Registers
always @(posedge clk_b or negedge brstn) begin
    if(!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

-- Output Assignment
always @(posedge clk_b or negedge brstn) begin
    if(!brstn) begin
        dataout <= 4'b0;
    end else begin
        if(en_clap_two) begin
            dataout <= data_reg;
        end
    end
end

endmodule