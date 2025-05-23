module RAM (
    input            clk,
    input            rst_n,

    input            write_en,
    input [7:0]      write_addr,
    input [5:0]      write_data,

    input            read_en,
    input [7:0]      read_addr,
    output reg [5:0] read_data
);

    // Parameter definitions
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // Memory array definition: 8 locations of 6 bits
    reg [WIDTH-1:0] mem[DEPTH-1:0];
    
    integer i;

    // Write Operation
    // Synchronous (clocked) with asynchronous reset.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear entire RAM memory.
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= {WIDTH{1'b0}};
        end else begin
            if (write_en)
                // Only use the lower 3 bits of the write_addr for addressing.
                mem[write_addr[2:0]] <= write_data;
        end
    end

    // Read Operation
    // Synchronous (clocked) with asynchronous reset.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset, clear read_data by setting each bit to '0'
            for (i = 0; i < WIDTH; i = i + 1)
                read_data[i] <= 1'b0;
        end else begin
            if (read_en)
                // Only use the lower 3 bits of the read_addr for addressing.
                read_data <= mem[read_addr[2:0]];
            else
                read_data <= {WIDTH{1'b0}};
        end
    end

endmodule