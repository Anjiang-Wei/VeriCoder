module width_8to16(
    input  clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Define the data_out register
wire [15:0] data_out_wire;

// Create a synchronizer to ensure proper clock synchronization
always @(posedge clk or negedge rst_n) begin
    // On reset, clear the data_out register to 0
    if (!rst_n) begin
        data_out_wire <= 0;
    end else begin
        // If the input data is valid and the flag signal is active...
        if (valid_in && !data_out_wire) begin
            // ... concatenate the contents of the data_lock register and the data_in register...
            data_out_wire = {data_in, data_lock};
            // ...and store it in the data_out register
            data_out <= data_out_wire;
        end
    end
end

// Define the valid output signal
always @* begin
    // If the input data is valid and the flag signal is active...
    if (valid_in && !data_out_wire) begin
        // ...generate a valid output signal...
        valid_out <= 1;
    end else begin
        // Otherwise, generate an invalid output signal
        valid_out <= 0;
    end
end