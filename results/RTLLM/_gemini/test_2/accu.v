module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

    reg [1:0] count;
    reg [7:0] data_buffer [3:0];
    reg [9:0] sum;

    // Reset logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            valid_out <= 1'b0;
            data_out <= 10'b0;
            sum <= 10'b0;
            for (int i = 0; i < 4; i = i + 1) begin
                data_buffer[i] <= 8'b0;
            end
        end else begin
            if (valid_in) begin
                // Store the input data into the buffer
                data_buffer[count] <= data_in;
                // Increment the count
                count <= count + 1'b1;
                // If 4 data inputs are received, calculate the sum
                if (count == 4) begin
                    sum <= data_buffer[0] + data_buffer[1] + data_buffer[2] + data_buffer[3];
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end
            end else begin
                // Reset the count if valid_in is low
                count <= 2'b00;
                valid_out <= 1'b0;
            end
        end
    end

    // Output the sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
        end else begin
            if (valid_out) begin
                data_out <= sum;
            end
        end
    end

endmodule