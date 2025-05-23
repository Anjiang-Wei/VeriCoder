module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [7:0] write_addr,
    input [5:0] write_data,
    
    input read_en,
    input [7:0] read_addr,
    output reg [5:0] read_data
);
    // Parameters for data width and memory depth
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Define the RAM array
    reg [WIDTH-1:0] RAM [DEPTH-1:0]; // Depth = 8, Width = 6

    // Reset and Write Logic
    integer i; // Loop variable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, initialize all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= 6'b000000;
            end
        end else if (write_en) begin
            // Write operation: write data to the specified address
            if (write_addr < DEPTH)
                RAM[write_addr] <= write_data;
        end
    end

    // Read Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, initialize the read_data output to 0
            read_data <= 6'b000000;
        end else if (read_en) begin
            // Read operation: output data from the specified address
            if (read_addr < DEPTH) 
                read_data <= RAM[read_addr];
            else
                read_data <= 6'b000000; // Out of range check (optional)
        end else begin
            // If read_en is not active, clear the output
            read_data <= 6'b000000;
        end
    end

endmodule