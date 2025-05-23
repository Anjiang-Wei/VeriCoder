module width_8to16(
    input 				   clk 		,
    input 				   rst_n		,
    input				      valid_in	,
    input	   [7:0]		   data_in	,
    
    output	reg			valid_out,
    output   reg [15:0]	data_out
);

// Define the data_out register
localparam WIDTH = 16;
reg [WIDTH-1:0] data_out_reg = { Width={1'b0}, Data={0{7{1'b0}}}};

// Configure the clock and reset signals
always #1 clkposedge => begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= {WIDTH{1'b0}};
    end else begin
        // Update the data_out register on the posedge of the clock
        data_out_reg[7:0] = data_in;
        // Set the valid flag to indicate the output is valid
        valid_out <= 1;
    end
end

always #1 rst_nnegedge => begin
    if (rst_n) begin
        valid_out <= 0;
        data_out <= {WIDTH{1'b0}};
    end else begin
        // Clear the data_out register on reset
        data_out_reg = {WIDTH-1:0}{1'b0};
    end
end

// Concatenate the data_in and data_out registers to generate the output
always #1 valid_in => begin
    if (valid_in && !data_out_reg[7]) begin
        // Concatenate the data_in and data_out registers
        data_out <= data_in + data_out_reg;
        // Set the valid flag to indicate the output is valid
        valid_out <= 1;
    end else begin
        // Set the valid flag to indicate the output is not valid
        valid_out <= 0;
    end
end