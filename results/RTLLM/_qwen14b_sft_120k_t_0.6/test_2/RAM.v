module RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0] write_addr,
	input [5:0] write_data,
	
	input read_en,
	input [7:0] read_addr,
	output reg [5:0] read_data
);
    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    reg [5:0] RAM [0:2**WIDTH-1];
    
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2**WIDTH; i = i + 1) begin
                RAM[i] <= 6'b0;
            end
        end else if (write_en) begin
            RAM[write_addr] <= write_data;
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= 6'b0;
        end else if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= 6'b0;
        end
    end
endmodule