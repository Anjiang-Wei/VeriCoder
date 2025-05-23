module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH+1:0] result,
    output reg o_en
);

reg [STG_WIDTH-1:0] stage_in [STG_WIDTH-1:0];
reg [STG_WIDTH-1:0] stage_out [STG_WIDTH-1:0];

reg en_synch;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 0;
        en_synch <= 0;
    end else begin
        o_en <= |stage_out[STG_WIDTH-1:0];
        en_synch <= i_en & ~en_synch;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_in[0] <= {adda[DATA_WIDTH-1:0], 0};
        stage_out[0] <= {addb[DATA_WIDTH-1:0], 0};
    end else begin
        if (en_synch) begin
            for (genvar i = STG_WIDTH-2; i >= 0; i--) begin
                if (i < DATA_WIDTH - 1) begin
                    stage_in[i+1] <= {stage_out[i][DATA_WIDTH+i:STG_WIDTH], 
                                     adda[DATA_WIDTH-i-2:DATA_WIDTH-i-1],
                                     addb[DATA_WIDTH-i-2:DATA_WIDTH-i-1]};
                end else begin
                    stage_in[i+1] <= {stage_out[i][DATA_WIDTH+i:STG_WIDTH], 
                                     adda[DATA_WIDTH-i-2:DATA_WIDTH-i-1],
                                     0};
                end
            end

            for (genvar i = STG_WIDTH-1; i >= 0; i--) begin
                if (i < DATA_WIDTH - 1) begin
                    stage_out[i] <= {stage_in[i][DATA_WIDTH+i:STG_WIDTH], 
                                     addb[DATA_WIDTH-i-2:DATA_WIDTH-i-1],
                                     adda[DATA_WIDTH-i-2:DATA_WIDTH-i-1]};
                end else begin
                    stage_out[i] <= {stage_in[i][DATA_WIDTH+i:STG_WIDTH], 
                                     addb[DATA_WIDTH-i-2:DATA_WIDTH-i-1],
                                     0};
                end
            end

            if (i_en) begin
                result <= {DATA_WIDTH{~&stage_out[0][DATA_WIDTH-1]}} |
                          stage_out[0];
            end else begin
                o_en <= 1;
            end
        end
    end
end

endmodule