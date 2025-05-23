module RAM (
    input               clk,
    input               rst_n,
    
    input               write_en,
    input   [7:0]       write_addr,
    input   [5:0]       write_data,
    
    input               read_en,
    input   [7:0]       read_addr,
    output  reg [5:0]   read_data
);

    // parameters
    localparam WIDTH = 6;
    localparam DEPTH = 8;

    // memory array: DEPTH words of WIDTH bits
    reg [WIDTH-1:0] ram [0:DEPTH-1];
    integer i, j;

    // write port with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // initialize all DEPTH locations to 0
            for (i = 0; i < DEPTH; i = i + 1) begin
                ram[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // use lower bits of write_addr to index DEPTH locations
            ram[write_addr[2:0]] <= write_data;
        end
    end

    // read port with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clear read_data bit‑by‑bit
            for (j = 0; j < WIDTH; j = j + 1) begin
                read_data[j] <= 1'b0;
            end
        end
        else if (read_en) begin
            read_data <= ram[read_addr[2:0]];
        end
        else begin
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule