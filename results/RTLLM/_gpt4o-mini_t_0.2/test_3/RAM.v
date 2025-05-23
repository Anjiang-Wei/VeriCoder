module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [2:0] write_addr,  // Limited to 3 bits for depth of 8
    input [5:0] write_data,
    
    input read_en,
    input [2:0] read_addr,   // Limited to 3 bits for depth of 8
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;

    reg [WIDTH-1:0] RAM [DEPTH-1:0];  // RAM array of depth 8 and width 6

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset RAM contents to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= 6'b000000;
            end
            read_data <= 6'b000000;  // Clear read_data on reset
        end else begin
            // Write operation
            if (write_en) begin
                RAM[write_addr] <= write_data;  // Write data to the RAM at the given address
            end
            
            // Read operation
            if (read_en) begin
                read_data <= RAM[read_addr];  // Read data from the RAM at the given address
            end else begin
                read_data <= 6'b000000;  // Clear read_data if read_en is not active
            end
        end
    end

endmodule