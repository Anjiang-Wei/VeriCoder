module RAM (
    input             clk,
    input             rst_n,
    
    input             write_en,
    input      [7:0]  write_addr,
    input      [5:0]  write_data,
    
    input             read_en,
    input      [7:0]  read_addr,
    output reg [5:0]  read_data
);

    // Parameter definition
    parameter WIDTH = 6;
    parameter DEPTH = 8;       // Only 8 locations are used

    // Memory array: DEPTH memory locations, each WIDTH bits wide.
    // Although the specification mentioned an array with 2**WIDTH locations,
    // we are only using DEPTH=8 locations.
    reg [WIDTH-1:0] mem [DEPTH-1:0];

    //
    // Write Operation:
    // On asynchronous reset (active-low), clear all memory locations.
    // Otherwise, if write_en is asserted, write write_data into the RAM location.
    // Note: Only the lower 3 bits of write_addr are used because DEPTH=8.
    //
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end 
        else begin
            if(write_en) begin
                mem[write_addr[2:0]] <= write_data;
            end
        end
    end

    //
    // Read Operation:
    // On asynchronous reset (active-low), clear read_data by clearing each bit.
    // Otherwise, if read_en is asserted, read the data from the RAM at the
    // location specified (using the lower 3 bits of read_addr) and output it.
    // If read_en is not asserted, read_data is cleared to 0.
    //
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(j = 0; j < WIDTH; j = j + 1) begin
                read_data[j] <= 1'b0;
            end
        end 
        else begin
            if(read_en) begin
                read_data <= mem[read_addr[2:0]];
            end 
            else begin
                read_data <= {WIDTH{1'b0}};
            end
        end
    end

endmodule