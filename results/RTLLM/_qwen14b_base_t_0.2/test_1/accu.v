module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg [7:0] data_reg [3:0]; // Register to hold 4 data inputs
    reg [9:0] sum; // Register to hold the sum of 4 data inputs
    reg [1:0] counter; // Counter to track the number of valid inputs received

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
            sum <= 10'b0;
            counter <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                data_reg[counter] <= data_in; // Store the incoming data
                counter <= counter + 1; // Increment the counter
                if (counter == 3) begin // If 4 data inputs have been received
                    sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3]; // Calculate the sum
                    data_out <= sum; // Output the sum
                    valid_out <= 1'b1; // Set valid_out to 1
                    counter <= 2'b0; // Reset the counter
                end
            end else begin
                valid_out <= 1'b0; // Reset valid_out if no valid input
            end
        end
    end
endmodule