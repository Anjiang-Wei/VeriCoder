module RAM #(
    parameter WIDTH = 6,
    parameter DEPTH = 8
)(
    input                   clk,
    input                   rst_n,
    
    input                   write_en,
    input      [7:0]        write_addr,
    input      [WIDTH-1:0]  write_data,
    
    input                   read_en,
    input      [7:0]        read_addr,
    output reg [WIDTH-1:0]  read_data
);

    // 8 locations of 6 bits each
    reg [WIDTH-1:0] RAM [0:DEPTH-1];
    integer i;

    // write port + reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // initialize all RAM locations to zero
            for (i = 0; i < DEPTH; i = i + 1) begin
                RAM[i] <= {WIDTH{1'b0}};
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end

    // read port + reset
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