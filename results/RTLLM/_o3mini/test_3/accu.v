module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

    // Internal registers: accumulator and counter for valid inputs received.
    reg [9:0] accum;         // 10-bit accumulator to store sum of 4 data_in values.
    reg [1:0] count;         // 2-bit counter to count valid data inputs (0 to 3).

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear accumulator, counter, output signals.
            accum      <= 10'd0;
            count      <= 2'd0;
            data_out   <= 10'd0;
            valid_out  <= 1'b0;
        end else begin
            // By default, valid_out is deasserted.
            valid_out <= 1'b0;
            if(valid_in) begin
                if(count == 2'd3) begin
                    // This is the 4th valid data_in.
                    data_out  <= accum + data_in; // Calculate final accumulated sum.
                    valid_out <= 1'b1;            // Assert valid_out for one cycle.
                    // Reset accumulator and counter for next round.
                    accum     <= 10'd0;
                    count     <= 2'd0;
                end else begin
                    // Accumulate the data_in.
                    accum <= accum + data_in;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule