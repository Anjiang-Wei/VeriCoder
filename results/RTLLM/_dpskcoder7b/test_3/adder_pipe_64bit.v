reg [DATA_WIDTH:0] s_sum;
    reg [DATA_WIDTH-1:0] s_a, s_b, s_sum_stg;
    reg s_i_en, s_o_en;
    
    // pipeline stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_a <= 0;
            s_b <= 0;
            s_i_en <= 0;
        end else begin
            s_a <= adda;
            s_b <= addb;
            s_i_en <= i_en;
        end
    end
    
    // pipeline stage 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_sum_stg <= 0;
            s_o_en <= 0;
        end else begin
            if (s_i_en) begin
                s_sum_stg <= s_a + s_b;
                s_o_en <= 1;
            end else begin
                s_o_en <= 0;
            end
        end
    end
    
    // pipeline stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_sum <= 0;
        end else begin
            if (s_o_en) begin
                s_sum <= s_sum_stg;
            end
        end
    end
    
    assign result = s_sum;
endmodule