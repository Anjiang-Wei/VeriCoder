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

// Define the RAM array
reg [DEPTH - 1 : 0] RAM [(2**WIDTH) - 1 : 0];

// Always blocks for write and read operations
always @(posedge clk or negedge rst_n) begin
    // On reset, clear all memory locations in the RAM array
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 0;
        end
    end
    
    // Write operation
    else if (write_en) begin
        // Calculate the write address and data
        int write_addr_int = write_addr;
        int write_data_int = write_data;
        
        // Write data to the RAM array
        for (int i = 0; i < DEPTH; i++) begin
            RAM[write_addr_int] <= write_data_int;
            write_addr_int += 1;
        end
    end
    
    // Read operation
    else if (read_en) begin
        // Calculate the read address and data
        int read_addr_int = read_addr;
        reg [5:0] read_data_int;
        
        // Read data from the RAM array
        for (int i = 0; i < DEPTH; i++) begin
            read_data_int <= RAM[read_addr_int];
            read_addr_int += 1;
        end
    end
end

// Output the read data
output reg [5:0] read_data;
assign read_data = RAM[read_addr];