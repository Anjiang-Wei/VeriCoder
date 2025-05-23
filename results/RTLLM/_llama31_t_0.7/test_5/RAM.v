module RAM (
    input clk,         // Clock signal used for synchronous operation.
    input rst_n,       // Active-low reset signal. Defined as 0 for reset and 1 for reset signal inactive.
    
    input write_en,     // Write enable signal to initiate a write operation.
    input [7:0]write_addr,// Address for the write operation.
    input [5:0]write_data, // Data to be written to the RAM.
    
    input read_en,      // Read enable signal to initiate a read operation.
    input [7:0]read_addr,// Address for the read operation.

    output reg [5:0]read_data// Output signal representing the data read from the RAM
);

parameter WIDTH = 6; // bit width of each memory location (6 bits)
parameter DEPTH = 8; // depth of the memory (8 locations)

reg [WIDTH-1:0]RAM [DEPTH-1:0]; // Define a register array with depth=8 and width=6

// Write Operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        RAM <= '{default : 6'b000000}; // Reset all memory locations to 0 on reset
    else if (write_en) begin
        RAM[write_addr] <= write_data; // Write data to the specified address
    end
end

// Read Operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        read_data <= 6'b000000; // Reset read_data register to 0 on reset
    else if (read_en) begin
        read_data <= RAM[read_addr]; // Assign data from the specified address to read_data
    end
end

endmodule