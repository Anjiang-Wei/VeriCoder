module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

    // Internal Signals
    reg [9:0] accum;          // Accumulator to store the sum of the 4 inputs
    reg [1:0] count;          // Counter to track the number of valid inputs received

    // Process Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all signals
            accum       <= 10'b0;
            count       <= 2'b0;
            data_out    <= 10'b0;
            valid_out   <= 1'b0;
        end else begin
            if (valid_in) begin
                // Accumulate the input data and increment the count
                accum <= accum + data_in;
                count <= count + 1;

                if (count == 2'b11) begin
                    // On the 4th valid input, set output and valid_out signal
                    data_out  <= accum + data_in;
                    valid_out <= 1'b1;

                    // Reset accumulator and counter for the next set of inputs
                    accum <= 10'b0;
                    count <= 2'b0;
                end else begin
                    // While waiting for 4 inputs, keep valid_out low
                    valid_out <= 1'b0;
                end
            end else begin
                // If valid_in is low, no new input is received
                valid_out <= 1'b0;
            end
        end
    end
endmodule