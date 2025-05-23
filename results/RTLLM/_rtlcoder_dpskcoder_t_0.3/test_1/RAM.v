module RAM(
    input clk,
    input rst_n,
    input [7:0] write_addr,
    input [5:0] write_data,
    input write_en,
    input [7:0] read_addr,
    input read_en,
    output reg [5:0] read_data
);

reg [5:0] mem [0:255];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b0;
    end else if (read_en) begin
        read_data <= mem[read_addr];
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 256; i = i + 1) begin
            mem[i] <= 6'b0;
        end
    end else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

endmodule