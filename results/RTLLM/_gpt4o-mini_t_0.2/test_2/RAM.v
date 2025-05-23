module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr, // Address should be 3 bits for depth of 8
    input [5:0] write_data,
    
    input read_en,
    input [2:0] read_addr, // Address should be 3 bits for depth of 8
    output reg [5:0] read_data
);
    
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Declare the RAM array
    reg [WIDTH-1:0] RAM [0:DEPTH-1]; // 8 locations of 6 bits each
    
    // Initialization on reset
    integer i;
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset RAM to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] = 6'b000000; 
            end
        end else if (write_en) begin
            // Write data to RAM at the specified address
            RAM[write_addr] = write_data;
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read_data to 0
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Read data from RAM at the specified address
            read_data <= RAM[read_addr];
        end else begin
            // If read_en is not active, clear read_data
            read_data <= 6'b000000;
        end
    end

endmodule