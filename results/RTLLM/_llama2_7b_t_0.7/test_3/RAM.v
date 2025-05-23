module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [7:0]write_addr,
    input [5:0]write_data,
    
    input read_en,
    input [7:0]read_addr,
    output reg [5:0]read_data
);

// RAM Array Definition
reg [DEPTH - 1 : 0] RAM [(2**WIDTH) - 1 : 0];

// Write Operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the RAM array
        for (int i = 0; i < DEPTH; i++) {
            RAM[i] = 0;
        }
    end else if (write_en) begin
        // Write data to the RAM array
        RAM[write_addr] = write_data;
    end
end

// Read Operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the read data register
        read_data = 0;
    end else if (read_en) begin
        // Read data from the RAM array
        read_data = RAM[read_addr];
    end
end