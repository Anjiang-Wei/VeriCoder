Please complete the code for the pipeline registers, the sum calculation, and the output enable signal (o_en) within the module as described above.

```verilog
    reg [STG_WIDTH-1:0] stg_en_r;
    reg [DATA_WIDTH-1:0] adda_stg [STG_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] addb_stg [STG_WIDTH-1:0];
    reg [DATA_WIDTH:0] sum_stg [STG_WIDTH-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stg_en_r <= 'b0;
        end
        else begin
            stg_en_r <= {stg_en_r[STG_WIDTH-2:0], i_en};
        end
    end

    genvar i;
    generate
        for (i = 0; i < STG_WIDTH; i = i + 1) begin : gen_stg
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    adda_stg[i] <= 'b0;
                    addb_stg[i] <= 'b0;
                    sum_stg[i] <= 'b0;
                end
                else if (stg_en_r[i]) begin
                    adda_stg[i] <= adda;
                    addb_stg[i] <= addb;
                    sum_stg[i] <= adda + addb;
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
        end
        else begin
            o_en <= stg_en_r[STG_WIDTH-1];
        end
    end

    assign result = sum_stg[STG_WIDTH-1];
endmodule