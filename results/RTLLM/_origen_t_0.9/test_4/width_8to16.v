module width_8to16(
	input 				   clk 		,
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);

  // Internal registers
  reg 			is_first_data;
  reg	[7:0]	data_lock;
  reg	[15:0]	data_out_temp;
  reg			flag;

  // Main logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      is_first_data <= 1'b1;
      data_lock <= 8'h00;
      data_out <= 16'h0000;
      valid_out <= 1'b0;
      flag <= 1'b0;
    end else begin
      if (valid_in) begin
        if (is_first_data) begin
          is_first_data <= 1'b0;
          data_lock <= data_in;
          flag <= 1'b1;
        end else begin
          is_first_data <= 1'b1;
          data_out_temp <= {data_lock, data_in};
          data_out <= data_out_temp;
          valid_out <= 1'b1;
          flag <= 1'b0;
        end
      end else begin
        valid_out <= 1'b0;
      end
    end
  end

endmodule