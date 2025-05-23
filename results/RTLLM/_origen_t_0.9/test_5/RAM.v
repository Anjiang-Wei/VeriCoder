module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [7:0] write_addr,
    input [5:0] write_data,
    
    input read_en,
    input [7:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    reg [WIDTH-1:0] RAM [DEPTH-1:0];
    reg [5:0] temp_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= 0;
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            temp_data <= 0;
        end else if (read_en) begin
            temp_data <= RAM[read_addr];
        end else begin
            temp_data <= 0;
        end
    end

    always @(*) begin
        read_data = temp_data;
    end

endmodule