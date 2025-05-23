module RAM (
    input wire clk,
    input wire rst_n,
    input wire [7:0] write_addr,
    input wire [5:0] write_data,
    input wire write_en,
    input wire [7:0] read_addr,
    input wire read_en,
    output reg [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0];

integer i;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 2**WIDTH; i = i + 1) begin
            RAM[i] <= 6'b000000;
        end
    end else begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b000000;
    end else begin
        if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= 6'b000000;
        end
    end
end

endmodule