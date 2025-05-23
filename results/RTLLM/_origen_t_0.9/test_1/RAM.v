Your implementation should include the necessary logic for the RAM array to hold 6-bit wide data at 8-bit addresses, and the behavior of read and write operations as described.

Note: 
- Ensure the read and write operations are mutually exclusive, and both operations can happen at the same time.
- The RAM array should be initialized to zero on reset and should maintain this state during normal operation.

Please provide a suitable implementation of the RAM module with the described functionality.

Module name:
    RAM

Input ports:
    clk: Clock signal for synchronous operations.
    rst_n: Active-low reset signal.
    write_en: Write enable signal for initiating write operations.
    write_addr: Address for write operations.
    write_data: Data to be written to the RAM.
    read_en: Read enable signal for initiating read operations.
    read_addr: Address for read operations.

Output ports:
    read_data: Output signal representing the data read from the RAM.

Parameter:
    WIDTH = 6
    DEPTH = 8

Implementation:
```verilog
module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
) (
    input clk,
    input rst_n,
    input write_en,
    input [WIDTH-1:0] write_addr,
    input [WIDTH-1:0] write_data,
    input read_en,
    input [WIDTH-1:0] read_addr,
    output reg [WIDTH-1:0] read_data
);

    reg [WIDTH-1:0] RAM [DEPTH-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule