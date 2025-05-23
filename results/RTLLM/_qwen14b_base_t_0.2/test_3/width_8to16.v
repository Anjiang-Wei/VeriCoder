module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output   reg			valid_out,
	output   reg [15:0]	data_out
);
    // Internal registers to store the first and second 8-bit data
    reg [7:0] data_lock;
    reg [7:0] data_in_reg;
    reg valid_flag;

    // Process to handle the data and valid signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            data_in_reg <= 8'b0;
            valid_flag <= 1'b0;
            valid_out <= 1'b0;
            data_out <= 16'b0;
        end else begin
            if (valid_in) begin
                if (valid_flag) begin
                    // Second valid data arrives, concatenate and output
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    valid_flag <= 1'b0; // Reset the flag after output
                end else begin
                    // First valid data arrives, store it
                    data_lock <= data_in;
                    valid_flag <= 1'b1;
                end
            end else begin
                // If no valid data, keep the previous state
                valid_out <= 1'b0;
                data_out <= 16'b0;
            end
        end
    end

endmodule