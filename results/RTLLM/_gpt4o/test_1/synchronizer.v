module synchronizer(
	input 				clk_a	, 
	input 				clk_b	,   
	input 				arstn	,
	input				brstn   ,
	input		[3:0]	data_in	,
	input               data_en ,

	output reg  [3:0] 	dataout
);

	// Intermediate registers
	reg [3:0] data_reg;              // Data register for clock domain A
	reg       en_data_reg;           // Enable register for clock domain A
	reg       en_clap_one;           // First level synchronization of enable in clock domain B
	reg       en_clap_two;           // Second level synchronization of enable in clock domain B

	// Clock domain A - Capture data and enable signal
	always @(posedge clk_a or negedge arstn) begin
		if (!arstn) begin
			data_reg <= 4'b0000;        // Reset data register
			en_data_reg <= 1'b0;        // Reset enable register
		end else begin
			if (data_en) begin
				data_reg <= data_in;    // Latch input data when enable is high
			end
			en_data_reg <= data_en;       // Latch enable signal
		end
	end

	// Clock domain B - Synchronize enable signal (2-stage flip-flops)
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			en_clap_one <= 1'b0;        // Reset first stage synchronization
			en_clap_two <= 1'b0;        // Reset second stage synchronization
		end else begin
			en_clap_one <= en_data_reg; // First stage of synchronization
			en_clap_two <= en_clap_one; // Second stage of synchronization
		end
	end

	// Clock domain B - Assign dataout based on enable control
	always @(posedge clk_b or negedge brstn) begin
		if (!brstn) begin
			dataout <= 4'b0000;         // Reset output data
		end else begin
			if (en_clap_two) begin
				dataout <= data_reg;    // Synchronize and transfer data to output
			end
			// Retain previous value of dataout if en_clap_two is not active
		end
	end

endmodule