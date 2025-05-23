```verilog
    reg [DATA_WIDTH-1:0] sum_reg [0:STG_WIDTH-1];
    reg [DATA_WIDTH-1:0] carry_reg [0:STG_WIDTH-1];
    reg [DATA_WIDTH-1:0] result_reg;
    reg [DATA_WIDTH-1:0] sum_pipe_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            o_en <= 0;
            result_reg <= 0;
            sum_pipe_reg <= 0;
        end else begin
            if (i_en) begin
                o_en <= 1;
                result_reg <= sum_pipe_reg;
            end else begin
                o_en <= 0;
                result_reg <= 0;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg[0] <= 0;
            carry_reg[0] <= 0;
        end else begin
            sum_reg[0] <= adda;
            carry_reg[0] <= 0;
        end
    end

    genvar i;
    generate
        for (i = 1; i < STG_WIDTH; i = i + 1) begin : gen_adder
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum_reg[i] <= 0;
                    carry_reg[i] <= 0;
                end else begin
                    sum_reg[i] <= sum_pipe_reg + addb;
                    carry_reg[i] <= sum_reg[i-1][DATA_WIDTH-1];
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_pipe_reg <= 0;
        end else begin
            sum_pipe_reg <= {carry_reg[STG_WIDTH-1], sum_reg[STG_WIDTH-1]};
        end
    end

    assign result = {carry_reg[STG_WIDTH-1], sum_pipe_reg};

endmodule