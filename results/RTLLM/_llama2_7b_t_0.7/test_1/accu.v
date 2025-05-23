module accu(
    input               clk         ,
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,

    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Define the module's inputs and outputs
localparam DATA_WIDTH = 10; // 8 bits for data input, 10 bits for output
localparam INPUT_WIDTH = 8; // 7 bits for data_in, 9 bits for data_out

// Define the signal variables
wire [DATA_WIDTH-1:0] data_in_wire; // Input data signal
wire [INPUT_WIDTH-1:0] valid_in_wire; // Input valid signal
wire [DATA_WIDTH-1:0] data_out_wire; // Output data signal
wire [1:0] valid_out_wire; // Output valid signal

// Initialize the signal variables
assign data_in_wire = data_in;
assign valid_in_wire = valid_in;
assign data_out_wire = 0;
assign valid_out_wire = 0;

// Accumulate input data and generate output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the signal variables
        data_in_wire <= 0;
        valid_in_wire <= 0;
        data_out_wire <= 0;
        valid_out_wire <= 0;
    end else if (valid_in_wire) begin
        // Accumulate input data and generate output
        data_out_wire <= data_in_wire + data_out_wire;
        valid_out_wire <= valid_in_wire && data_out_wire === 4'b0; // Check if 4 inputs have been accumulated
    end else begin
        // No output when there are fewer than 4 input data
        valid_out_wire <= 0;
    end
end

// Map the signal variables to the module's output ports
assign data_out = {DATA_WIDTH{data_out_wire[7]}};
assign valid_out = valid_out_wire;