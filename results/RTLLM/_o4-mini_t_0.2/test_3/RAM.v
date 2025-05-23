module RAM (
    input               clk,
    input               rst_n,
    
    input               write_en,
    input       [7:0]   write_addr,
    input       [5:0]   write_data,
    
    input               read_en,
    input       [7:0]   read_addr,
    output reg  [5:0]   read_data
);

    // parameterization
    parameter WIDTH = 6;
    parameter DEPTH = 8;

    // RAM array: DEPTH words of WIDTH‑bit each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];

    integer i, j;

    //========================================================================
    // Write Port: clear on reset, otherwise write when write_en is asserted
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // initialize all DEPTH locations to zero
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // use lower bits of write_addr to index the DEPTH‑deep memory
            RAM[ write_addr[2:0] ] <= write_data;
        end
    end

    //========================================================================
    // Read Port: clear read_data on reset or when read_en is deasserted
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clear each bit of read_data
            for (j = 0; j < WIDTH; j = j + 1) begin
                read_data[j] <= 1'b0;
            end
        end
        else if (read_en) begin
            read_data <= RAM[ read_addr[2:0] ];
        end
        else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule