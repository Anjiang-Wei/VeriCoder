module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr, // Address should be 3 bits for 8 depth (2^3 = 8)
    input [5:0] write_data,
    
    input read_en,
    input [2:0] read_addr, // Address should be 3 bits for 8 depth
    output reg [5:0] read_data
);

// Parameters for width and depth
parameter WIDTH = 6;
parameter DEPTH = 8;

// Memory array definition
reg [WIDTH-1:0] RAM [0:DEPTH-1]; // 8 depth of 6-bit register

// Always block for write operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset RAM contents to 0 on reset
        integer i;
        for (i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] = 6'b000000;
        end
    end else begin
        // Perform write operation if enabled
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end
end

// Always block for read operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset read_data on reset
        read_data <= 6'b000000;
    end else begin
        // Perform read operation if enabled
        if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            // Clear read_data if read_en is not active
            read_data <= 6'b000000;
        end
    end
end

endmodule