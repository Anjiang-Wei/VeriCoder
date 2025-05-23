module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   rst_n,
    
    // write port
    input                   write_en,
    input   [7:0]           write_addr,   // only lower $clog2(DEPTH) bits used
    input   [WIDTH-1:0]     write_data,
    
    // read port
    input                   read_en,
    input   [7:0]           read_addr,    // only lower $clog2(DEPTH) bits used
    output reg [WIDTH-1:0]  read_data
);

    // Memory array: DEPTH entries, each WIDTH bits wide
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    //========================================================================
    // Write process (synchronous, with async reset)
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clear entire memory on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // write data into addressed location
            RAM[write_addr[$clog2(DEPTH)-1:0]] <= write_data;
        end
    end

    //========================================================================
    // Read process (synchronous, with async reset)
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            // read data from addressed location
            read_data <= RAM[read_addr[$clog2(DEPTH)-1:0]];
        end
        else begin
            // output zeros when not enabled
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule