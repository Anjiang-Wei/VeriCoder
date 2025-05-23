module RAM (
    input clk,
    input rst_n, // Active-low reset signal
    
    input write_en, // Write enable signal to initiate a write operation
    input [7:0]write_addr, // Address for the write operation
    input [5:0]write_data, // Data to be written to the RAM
    
    input read_en, // Read enable signal to initiate a read operation
    input [7:0]read_addr, // Address for the read operation
    
    output reg [5:0]read_data // Output signal representing the data read from the RAM
);
    
    parameter WIDTH = 6; // Bit width of the RAM
    parameter DEPTH = 8; // Depth of the RAM

    reg [2**WIDTH-1:0][WIDTH-1:0] RAM; // Define the RAM array with a depth of 2^6 and a bit width of 6 bits
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin // On reset, clear all memory locations in the RAM array to 0
            for (int i = 0; i < DEPTH; i++) begin
                RAM[i] = 'b000000;
            end
        end
        
        if (write_en) begin // If write enable is active, write data to the specified address
            RAM[write_addr] = write_data;
        end
    end
    
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin // On reset, clear the read_data register to 0
            read_data <= 'b000000;
        end
        
        if (read_en) begin // If read enable is active, assign data at the specified address to the read_data register
            read_data <= RAM[read_addr];
        end
        else begin // If read enable is not active, clear the read_data register to 0
            read_data <= 'b000000;
        end
    end
    
endmodule