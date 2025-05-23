module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr,  // Address width modified to match DEPTH=8 (3 bits)
    input [5:0] write_data,
    
    input read_en,
    input [2:0] read_addr,   // Address width modified to match DEPTH=8 (3 bits)
    output reg [5:0] read_data
);

    // Parameters
    parameter WIDTH = 6;  // Data width
    parameter DEPTH = 8;  // Memory depth
    
    // RAM Array Declaration
    reg [WIDTH-1:0] RAM [DEPTH-1:0]; // 8 memory locations, each 6 bits wide

    // Write Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Clear all memory locations to 0
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}}; // Clear each location to 000000
            end
        end else if (write_en) begin
            // Write data to the specified address
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Clear read_data to 0
            read_data <= {WIDTH{1'b0}}; // Set read_data to 000000
        end else if (read_en) begin
            // Read data from the specified address
            read_data <= RAM[read_addr];
        end else begin
            // If read_en is not active, clear read_data to 0
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule