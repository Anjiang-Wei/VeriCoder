module RAM (
    input clk,
    input rst_n,
    
    input write_en,
    input [7:0]write_addr,
    input [5:0]write_data,
    
    input read_en,
    input [7:0]read_addr,
    output reg [5:0]read_data
);

// RAM Array Definition
reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0];

// Write Operation
always @(posedge clk or negedge rst_n) begin
    // On Reset, Clear Memory Locations
    if (!rst_n) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[i] <= 0;
        end
    end
    
    // On Write Enable, Write Data to Memory
    else if (write_en) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM[write_addr + i * 8] <= write_data;
        end
    end
end

// Read Operation
always @(posedge clk or negedge rst_n) begin
    // On Reset, Clear Read Data Register
    if (!rst_n) begin
        read_data <= 0;
    end
    
    // On Read Enable, Read Data from Memory
    else if (read_en) begin
        for (int i = 0; i < DEPTH; i++) begin
            read_data[i * 8 +: 5] <= RAM[read_addr + i * 8];
        end
    end
end