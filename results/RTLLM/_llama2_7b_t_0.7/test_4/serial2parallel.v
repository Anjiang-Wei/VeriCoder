module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0]dout_parallel,
    output reg dout_valid
);

// Counter to keep track of serial input bits received
reg [3:0]cnt = 0;

always@(posedge clk or negedge rst_n) begin
    // Reset the counter on reset
    if (rst_n) begin
        cnt <= 0;
    end else begin
        // Increment the counter every time a serial input bit is received
        cnt <= cnt + 1;
        
        // Check if enough serial input bits have been received to produce a parallel output
        if (cnt == 8) begin
            // Set the valid output signal to 1 to indicate that the parallel output data is valid
            dout_valid <= 1;
            
            // Initialize the parallel output data with the received serial data
            dout_parallel <= din_serial;
        end else begin
            // Set the valid output signal to 0 to indicate that the parallel output data is not valid
            dout_valid <= 0;
        end
    end
end