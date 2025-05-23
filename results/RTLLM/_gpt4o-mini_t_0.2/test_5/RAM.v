module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr, // 3 bits for depth of 8 (2^3)
    input [5:0] write_data,
    
    input read_en,
    input [2:0] read_addr, // 3 bits for depth of 8 (2^3)
    output reg [5:0] read_data
);

    // Parameter Definitions
    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // RAM Array
    reg [WIDTH-1:0] RAM [0:DEPTH-1]; // 8 locations of 6 bits each

    // Write Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] = 6'b000000;
            end
        end else if (write_en) begin
            // Write data to specified address
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b000000; // Initialize read_data to 0 on reset
        end else if (read_en) begin
            // Read data from specified address
            read_data <= RAM[read_addr];
        end else begin
            read_data <= 6'b000000; // Clear read_data if not reading
        end
    end

endmodule