module RAM (
    input               clk,
    input               rst_n,
    
    input               write_en,
    input  [7:0]        write_addr,
    input  [5:0]        write_data,
    
    input               read_en,
    input  [7:0]        read_addr,
    output reg [5:0]    read_data
);

    // ----------------------------------------------------
    // parameters
    // ----------------------------------------------------
    localparam WIDTH = 6;
    localparam DEPTH = 8;
    
    // ----------------------------------------------------
    // internal memory declaration
    // ----------------------------------------------------
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    integer i;
    
    // ----------------------------------------------------
    // write port: synchronous, active write_en, auto‐clear on reset
    // ----------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // clear entire memory to 0 on reset
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {WIDTH{1'b0}};
            end
        end
        else if (write_en) begin
            // only write if address is in range
            if (write_addr < DEPTH)
                mem[write_addr] <= write_data;
        end
    end
    
    // ----------------------------------------------------
    // read port: synchronous, active read_en, auto‐clear on reset or when read_en=0
    // ----------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            // only read if address is in range, else output zeros
            if (read_addr < DEPTH)
                read_data <= mem[read_addr];
            else
                read_data <= {WIDTH{1'b0}};
        end
        else begin
            // when read_en is low, drive output back to zero
            read_data <= {WIDTH{1'b0}};
        end
    end

endmodule