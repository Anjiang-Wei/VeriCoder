module RAM (
    input clk,          // Clock signal used for synchronous operation.
    input rst_n,        // Active-low reset signal. Defined as 0 for reset and 1 for reset signal inactive.

    input write_en,     // Write enable signal to initiate a write operation.
    input [7:0]write_addr, // Address for the write operation.
    input [5:0]write_data, // Data to be written to the RAM.

    input read_en,      // Read enable signal to initiate a read operation.
    input [7:0]read_addr, // Address for the read operation.

    output reg [5:0]read_data  // Output signal representing the data read from the RAM.
);

// Parameter definition
parameter WIDTH = 6;
parameter DEPTH = 8;

// RAM Array
reg [WIDTH-1:0] RAM [(2**WIDTH)-1:0];

initial begin
    for (int i = 0; i < (2 ** WIDTH); i++) begin
        RAM[i] = 6'b000000;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < (2 ** WIDTH); i++) begin
            RAM[i] = 6'b000000;
        end
        read_data <= 6'b000000;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 6'b000000;
    end else if (write_en && !read_en) begin
        RAM[write_addr] <= write_data;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (read_en) begin
        read_data <= RAM[read_addr];
    end else begin
        read_data <= 6'b000000;
    end
end

endmodule