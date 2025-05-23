module width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
	output   reg			valid_out,
	output   reg [15:0]	data_out
);
    // Internal registers
    reg [7:0] data_lock;
    reg [7:0] data_in_reg;
    reg valid_flag;

    // On reset, clear the data_out and valid_out signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
        end else if (valid_flag) begin
            // Concatenate the locked data and the current data_in
            data_out <= {data_lock, data_in_reg};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    // Process valid_in and data_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            data_in_reg <= 8'b0;
            valid_flag <= 1'b0;
        end else if (valid_in) begin
            if (valid_flag) begin
                // Second valid data arrives, lock it and set the flag to 0
                data_lock <= data_in_reg;
                valid_flag <= 1'b0;
            end else begin
                // First valid data arrives, lock it and set the flag to 1
                data_lock <= data_in;
                valid_flag <= 1'b1;
                data_in_reg <= data_in;
            end
        end
    end
endmodule