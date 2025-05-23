# Module implementation

reg [STG_WIDTH-1:0] i_en_r;
reg [STG_WIDTH-1:0] o_en_r;
reg [DATA_WIDTH-1:0] adda_r [STG_WIDTH:0];
reg [DATA_WIDTH-1:0] addb_r [STG_WIDTH:0];
reg [DATA_WIDTH:0] sum [STG_WIDTH:0];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_r <= {STG_WIDTH{1'b0}};
        o_en_r <= {STG_WIDTH{1'b0}};
        adda_r[0] <= {DATA_WIDTH{1'b0}};
        addb_r[0] <= {DATA_WIDTH{1'b0}};
        for (int i = 0; i < STG_WIDTH; i++) begin
            adda_r[i+1] <= {DATA_WIDTH{1'b0}};
            addb_r[i+1] <= {DATA_WIDTH{1'b0}};
            sum[i+1] <= {DATA_WIDTH+1{1'b0}};
        end
    end
    else begin
        i_en_r[0] <= i_en;
        o_en_r[0] <= i_en_r[STG_WIDTH-1];

        adda_r[0] <= adda;
        addb_r[0] <= addb;
        sum[0] <= {1'b0, adda + addb};

        for (int i = 0; i < STG_WIDTH; i++) begin
            i_en_r[i+1] <= i_en_r[i];
            o_en_r[i+1] <= o_en_r[i];
            adda_r[i+1] <= adda_r[i];
            addb_r[i+1] <= addb_r[i];
            sum[i+1] <= sum[i];
        end
    end
end

assign result = sum[STG_WIDTH];
assign o_en = o_en_r[STG_WIDTH];