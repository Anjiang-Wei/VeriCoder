module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output reg        valid_out    ,
    output reg [9:0]  data_out
);

    // Internal accumulator: 10 bits wide since maximum sum (4×255=1020) fits in 10 bits.
    reg [9:0] acc;
    // 2-bit counter to count from 0 to 3 (i.e., 4 valid inputs).
    reg [1:0] count;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc       <= 10'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end
        else begin
            // By default, valid_out is de-asserted each clock cycle.
            valid_out <= 1'b0;
            
            if(valid_in) begin
                // Check if we are receiving the fourth valid input.
                if(count == 2'd3) begin
                    // On the fourth valid input, add the current data_in 
                    // to the accumulator, output the result, and set valid_out.
                    data_out  <= acc + data_in;
                    valid_out <= 1'b1;
                    // Reset accumulator and counter for the next accumulation sequence.
                    acc   <= 10'd0;
                    count <= 2'd0;
                end
                else begin
                    // For first three valid inputs, continue accumulating.
                    acc   <= acc + data_in;
                    count <= count + 2'd1;
                end
            end
        end
    end

endmodule