module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg [31:0] accumulated; // Accumulator for the sum of four 8-bit data values.
reg [$clog2(4) : 0] count; // Counter to track how many valid inputs have been received.

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        begin
            accumulated <= 'b0;
            count <= $zero;
            valid_out <= 'b0;
        end
    else if (valid_in)
        begin
            // Count valid inputs and accumulate data.
            count <= count + 1;
            case(count)
                4'd1: accumulated = data_in; // Accumulate first input directly for simplicity.
                default:
                    begin
                        // Accumulate subsequent inputs by adding to the current value of accumulated.
                        accumulated = (accumulated << 8) | data_in;
                    end
            endcase
        end
    else
        count <= $zero; // Reset counter when no valid inputs are present.

    // Output data_out as the accumulated sum and set valid_out to indicate four accumulations have been reached.
    if (count == 'b111)
        begin
            data_out = accumulated;
            valid_out <= 'b1;
        end
    else
        valid_out <= 'b0;

end

endmodule // accu