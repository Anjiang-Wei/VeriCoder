module RAM (
    input         clk,
    input         rst_n,
    
    input         write_en,
    input  [7:0]  write_addr,
    input  [5:0]  write_data,
    
    input         read_en,
    input  [7:0]  read_addr,
    output reg [5:0] read_data
);

  // Parameter definitions
  parameter WIDTH = 6;
  parameter DEPTH = 8;

  // Memory array: 8 locations of 6 bits each
  reg [WIDTH-1:0] mem [DEPTH-1:0];

  // Loop variable for reset initialization
  integer i;

  // Write operation: reset all memory locations to 0 on reset, 
  // otherwise write data if write enable is high.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i = 0; i < DEPTH; i = i + 1)
        mem[i] <= {WIDTH{1'b0}};
    end else begin
      if (write_en)
        // Using only 3 bits from the write address to index the 8-element RAM
        mem[write_addr[2:0]] <= write_data;
    end
  end

  // Read operation: reset read_data on reset, 
  // if read enable is high then output the value present at given address,
  // otherwise clear read_data to 0.
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      // Initialize each bit of read_data to 0 using a for loop.
      for (i = 0; i < WIDTH; i = i + 1)
        read_data[i] <= 1'b0;
    end else begin
      if (read_en)
        // Using only 3 bits from the read address to index the memory
        read_data <= mem[read_addr[2:0]];
      else
        read_data <= {WIDTH{1'b0}};
    end
  end

endmodule