module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr,  // Depth is 8, so address width is log2(8) = 3 bits
    input [5:0] write_data,  // Width of each word is 6 bits
    
    input read_en,
    input [2:0] read_addr,   // Depth is 8, so address width is log2(8) = 3 bits
    output reg [5:0] read_data  // Output register for read data
);

    parameter WIDTH = 6;   // Bit width of the data
    parameter DEPTH = 8;   // Depth of the RAM

    // Declare the RAM array
    reg [WIDTH-1:0] RAM [DEPTH-1:0];

    integer i;

    // Write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Write data to the specified address
            RAM[write_addr] <= write_data;
        end
    end

    // Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read_data to 0
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Read data from the specified address
            read_data <= RAM[read_addr];
        end else begin
            // Clear read_data if read enable is not active
            read_data <= 6'b000000;
        end
    end

endmodule