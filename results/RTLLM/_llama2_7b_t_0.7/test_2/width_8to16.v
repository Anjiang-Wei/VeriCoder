module width_8to16(
    input 				   clk 		,    
    input 				   rst_n		,     
    input				       valid_in	,     
    input	   [7:0]		   data_in	,    
    output	reg			   valid_out,    
    output   reg [15:0]	data_out    
);
 
  // Define the data_out register as a 16-bit integer
  localparam DATA_WIDTH = 16;
  parameter [DATA_WIDTH-1:0] DATA_OFFSET = {DATA_WIDTH{1'b0}};
  
  // Define the data_lock register as a 8-bit integer
  localparam DATA_LOCK_WIDTH = 8;
  parameter [DATA_LOCK_WIDTH-1:0] DATA_LOCK_OFFSET = {DATA_LOCK_WIDTH{1'b0}};
  
  // Construct the data_out register by concatenating the data_lock and data_in registers
  reg [DATA_WIDTH-1:0] data_out = {DATA_LOCK_WIDTH{1'b0}, data_in};
  
  // Set the initial value of the data_out register to zero
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_out <= {DATA_WIDTH{1'b0}, 0};
    end else begin
      // If the input valid signal is high and the flag signal is active, update the data_out register
      if (valid_in & !data_lock) begin
        data_out <= {DATA_LOCK_WIDTH{1'b0}, data_in};
      end
    end
  end
  
  // Define the valid_out and data_out signals as regs
  reg valid_out;
  reg [15:0] data_out;
  
endmodule