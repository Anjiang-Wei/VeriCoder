module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg [7:0] data_reg [3:0]; // Register to hold the last 4 data inputs
    reg [9:0] sum;           // Register to hold the sum of the 4 data inputs
    reg [1:0] count;         // Counter to keep track of the number of valid inputs received

    // Initialize registers on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0; // Clear data registers
            sum <= 10'b0;     // Clear sum register
            count <= 2'b0;    // Reset counter
            valid_out <= 1'b0; // Clear valid_out signal
        end else begin
            if (valid_in) begin
                // Shift the data registers to the left and store the new data
                data_reg[3] <= data_reg[2];
                data_reg[2] <= data_reg[1];
                data_reg[1] <= data_reg[0];
                data_reg[0] <= data_in;

                // Increment the count
                count <= count + 1;
            end

            // Calculate the sum when we have 4 valid inputs
            if (count == 4'b100) begin
                sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1'b1; // Set valid_out to 1
            end else begin
                valid_out <= 1'b0; // Otherwise, keep valid_out at 0
            end
        end
    end

    // Assign the sum to data_out
    assign data_out = sum;

endmodule