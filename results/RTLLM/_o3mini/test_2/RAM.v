module RAM (
    input        clk,
    input        rst_n,

    input        write_en,
    input  [7:0] write_addr,
    input  [5:0] write_data,

    input        read_en,
    input  [7:0] read_addr,
    output reg [5:0] read_data
);

    // Parameter definitions
    parameter WIDTH = 6;
    parameter DEPTH = 8;  // RAM depth of 8 locations

    // RAM array: DEPTH locations, each WIDTH bits wide.
    // Although write_addr and read_addr are 8-bits wide, only the lower 3 bits are used to index 8 locations.
    reg [WIDTH-1:0] RAM [DEPTH-1:0];

    integer i;

    // Write Operation
    // This always block handles synchronous write and synchronous reset for the RAM array.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else begin
            // If write enable is high, write the provided data to the specified address.
            if (write_en) begin
                RAM[write_addr[2:0]] <= write_data;
            end
        end
    end

    // Read Operation
    // This always block handles reading the data from the RAM array synchronously.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear the read_data register.
            // Using a for loop style assignment (unrolled by the synthesis tool) to reset bits individually.
            // (Although a simple assignment would work as well.)
            begin : reset_read_data
                integer j;
                for (j = 0; j < WIDTH; j = j + 1) begin
                    read_data[j] <= 1'b0;
                end
            end
        end else begin
            if (read_en) begin
                // When read enabled, assign the content of the specified memory location.
                read_data <= RAM[read_addr[2:0]];
            end else begin
                // When read enable is inactive, clear read_data.
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule