module RAM (
    input clk,
    input rst_n,
	
    input write_en,
    input [2:0] write_addr,    // Address width for DEPTH = 8
    input [5:0] write_data,    // Data width = 6
	
    input read_en,
    input [2:0] read_addr,     // Address width for DEPTH = 8
    output reg [5:0] read_data // Data width = 6
);

    // Parameter Definitions
    parameter WIDTH = 6; // Data width
    parameter DEPTH = 8; // Memory depth

    // Declare memory array
    reg [WIDTH-1:0] RAM [DEPTH-1:0];
	
    integer i; // Loop variable for reset operation

    // Write Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0 on active-low reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            // Perform write operation when write_en is active
            RAM[write_addr] <= write_data;
        end
    end

    // Read Operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear read_data to 0 on active-low reset
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            // Perform read operation when read_en is active
            read_data <= RAM[read_addr];
        end else begin
            // Clear read_data to 0 if read_en is not active
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule