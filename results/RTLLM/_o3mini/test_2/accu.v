module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out ,
    output  reg [9:0]   data_out
);

    // Internal registers
    reg [9:0] sum;     // accumulation register: maximum value 4*255=1020 (10-bit required)
    reg [1:0] count;   // counter for 0-3 (counts valid inputs)

    // Synchronous process for accumulation and output generation.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum       <= 10'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= 1'b0; // default: no valid output unless 4 data received.
            if (valid_in) begin
                if (count == 2'd3) begin
                    // Fourth valid input: output the accumulated sum plus the current data_in.
                    data_out  <= sum + data_in;
                    valid_out <= 1'b1; // assert valid output for one cycle.
                    // reset the accumulator and counter.
                    sum   <= 10'd0;
                    count <= 2'd0;
                end
                else begin
                    // Otherwise, accumulate the incoming data and increment count.
                    sum   <= sum + data_in;
                    count <= count + 2'd1;
                end
            end
        end
    end

endmodule