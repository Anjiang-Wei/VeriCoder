module accu(
    input               clk,   
    input               rst_n,
    input       [7:0]   data_in, 
    input               valid_in,

    output  reg         valid_out,  
    output  reg [9:0]   data_out
);
    
    reg [7:0] data_accumulator; // accumulator for storing the sum of 4 data_in values
    reg [1:0] count;             // counter to track the number of valid data_in inputs
    
    always @(posedge clk) begin
        if (~rst_n) begin
            data_accumulator <= 'b0;
            count <= 'b00;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            case (count)
                2'd0: 
                    data_accumulator <= data_in;
                2'd1:
                    data_accumulator[7:0] <= {data_accumulator[7:0], data_in};
                2'd2:
                    data_accumulator[9:8] <= {data_accumulator[9:8], data_in[7:0]};
                default:
                    count <= 4'd1;
                    valid_out <= 1'b1; // set valid_out to 1 when all 4 inputs have been received
            endcase
            if (count == 2'd3) begin // increment the counter by 1 for each new input
                count <= 'b0;
            end else begin
                count <= count + 1;
            end
        end
    end
    
    assign data_out = {data_accumulator, 1'b0}; // combine the accumulator and a zero bit to form the output data_out

endmodule