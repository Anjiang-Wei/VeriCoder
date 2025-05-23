module RAM (
    input         clk,
    input         rst_n,
    
    input         write_en,
    input  [7:0]  write_addr,
    input  [5:0]  write_data,
    
    input         read_en,
    input  [7:0]  read_addr,
    output reg [5:0] read_data
);

    // Parameter declarations
    parameter WIDTH = 6;   // Data width
    parameter DEPTH = 8;   // Number of memory words

    // Define the memory array: DEPTH words of WIDTH bits
    reg [WIDTH-1:0] mem [DEPTH-1:0];
    
    integer i; // loop index for resets

    // Write Operation: 
    // On reset (active low) clear each memory location.
    // Otherwise, if write_en is high, write write_data into the memory at address write_addr.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear the RAM array at reset
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end
        else begin
            if (write_en) begin
                // Use lower 3 bits of write_addr to index the 8 locations.
                mem[write_addr[2:0]] <= write_data;
            end
        end
    end

    // Read Operation: 
    // On reset, clear every bit in read_data using a loop.
    // Otherwise, if read_en is high, output the data stored at the address read_addr.
    // If read_en is not active, clear read_data.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset read_data using a loop through its bits.
            for (i = 0; i < WIDTH; i = i + 1)
                read_data[i] <= 1'b0;
        end
        else begin
            if (read_en)
                // Use lower 3 bits of read_addr to index the 8 locations.
                read_data <= mem[read_addr[2:0]];
            else
                read_data <= 6'b000000;
        end
    end

endmodule