module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output	reg			valid_out,
	output   reg [15:0]	data_out
);
    reg [7:0] data_lock;
    reg flag;

    // Data lock register is updated on the positive edge of the clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            flag <= 1'b0;
        end else if (valid_in && !flag) begin
            // Store the first valid input data
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin
            // Concatenate the second valid input data with the stored data
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1;
            flag <= 1'b0;
        end
    end

endmodule