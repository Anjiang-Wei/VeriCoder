module RAM (
    input clk, // Clock signal used for synchronous operation.
    input rst_n, // Active-low reset signal.

    input write_en, // Write enable signal to initiate a write operation.
    input [7:0]write_addr, // Address for the write operation.
    input [5:0]write_data, // Data to be written to the RAM.

    input read_en, // Read enable signal to initiate a read operation.
    input [7:0]read_addr, // Address for the read operation.

    output reg [5:0]read_data // Output signal representing the data read from the RAM.
);

// Parameter definition
parameter WIDTH = 6;
parameter DEPTH = 8;

// Register array declaration
reg [WIDTH-1:0] RAM [(2**WIDTH)-1:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the memory on active-low reset signal
        for (int i = 0; i < (2 ** WIDTH); i++) begin
            RAM[i] <= 6'b000000;
        end
    end else begin
        if (write_en) begin
            // Write data to the specified address in the RAM array
            RAM[write_addr] <= write_data;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the read_data register on active-low reset signal
        read_data <= 6'b000000;
    end else begin
        if (read_en) begin
            // Assign data at specified address in RAM array to read_data register
            read_data <= RAM[read_addr];
        end else begin
            // Clear read_data register when read_en is inactive
            read_data <= 6'b000000;
        end
    end
end

endmodule