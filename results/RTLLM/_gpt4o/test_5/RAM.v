module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr, // Since DEPTH = 8, we need 3 bits for addressing.
    input [5:0] write_data, // Data width is 6 bits.
    
    input read_en,
    input [2:0] read_addr, // Same addressing as write_addr.
    output reg [5:0] read_data // Data width is 6 bits.
);
    // Parameter Definitions
    parameter WIDTH = 6;       // Data width is 6 bits.
    parameter DEPTH = 8;       // Memory depth is 8 locations.

    // Declare memory array for dual-port RAM.
    reg [WIDTH-1:0] RAM [DEPTH-1:0]; 

    // Integer for reset operation.
    integer i;

    // Write Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory elements to 0.
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= 6'b000000; 
            end
        end
        else if (write_en) begin
            // Write data to RAM at specified address.
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read_data to 0.
            read_data <= 6'b000000;
        end
        else if (read_en) begin
            // Read data from RAM at specified address if enabled.
            read_data <= RAM[read_addr];
        end
        else begin
            // Clear read_data to 0 if read operation is not enabled.
            read_data <= 6'b000000;
        end
    end

endmodule