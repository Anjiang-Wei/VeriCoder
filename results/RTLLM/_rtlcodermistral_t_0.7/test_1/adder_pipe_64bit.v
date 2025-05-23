```verilog
    reg [DATA_WIDTH-1:0] sum_reg[STG_WIDTH-1:0];
    reg [STG_WIDTH-1:0] carry_reg;
    integer i;
    
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_reg[i] <= {DATA_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
            end
            o_en <= 1'b0;
        end
        else begin
            if (i_en) begin
                for (i = 0; i < STG_WIDTH-1; i = i + 1) begin
                    sum_reg[i+1] <= sum_reg[i] + (adda[i:i] ^ addb[i:i]) + carry_reg[i];
                    carry_reg[i+1] <= (adda[i:i] & addb[i:i]) | (carry_reg[i] & (adda[i:i] ^ addb[i:i]));
                end
                sum_reg[STG_WIDTH-1] <= sum_reg[STG_WIDTH-2] + (adda[DATA_WIDTH-1:STG_WIDTH-1] ^ addb[DATA_WIDTH-1:STG_WIDTH-1]) + carry_reg[STG_WIDTH-2];
                carry_reg[STG_WIDTH-1] <= (adda[DATA_WIDTH-1:STG_WIDTH-1] & addb[DATA_WIDTH-1:STG_WIDTH-1]) | (carry_reg[STG_WIDTH-2] & (adda[DATA_WIDTH-1:STG_WIDTH-1] ^ addb[DATA_WIDTH-1:STG_WIDTH-1]));
                result <= {carry_reg[STG_WIDTH-1], sum_reg[STG_WIDTH-1]};
                o_en <= (STG_WIDTH == 1) ? 1'b1 : (STG_WIDTH > 1) ? (sum_reg[STG_WIDTH-2] != {DATA_WIDTH{1'b0}}) : 1'b0;
            end
        end
    end
endmodule