module accumulator(
    input                 clk         , 
    input               rst_n       ,
    input        [7:0]   data_in     ,
    input                valid_in     ,
 
    output reg             valid_out     ,
    output                 data_out
);

//wire[9:0] data_sum; //10-bit output data representing the accumulated sum of four input data values

//register operation 
always @(posedge clk) begin
if(rst_n) data_out <= 'd0;
else if(valid_in && !data_out[3:0])   //the current output is 4-bits. when the next input comes in, 1 should be added to the previous sum and outputted as a new 4-bit sum
    data_out <= data_sum + {data_in[7],data_in[6:0]};
else if(valid_in)   //the current output is 3 bits. when the next input comes in, one should be added to the previous sum and outputted as a new 4-bit sum.
    data_out <= data_sum + {data_in[7:0]};
else
    data_out <= 'd0; //when there are fewer than four data_in inputs in the interim, output will be zero
end
//register operation to count how many times valid_in has been 1 so that it can set its output signal to indicate when the current output is a result of four input data accumulation.
always @(posedge clk) begin
if(rst_n) valid_out <= 'd0;
else if(valid_in) valid_out <= valid_out + 1'b1; //count how many times the previous signal was 1 so that it can set its output when it is a result of four input data accumulation
end

endmodule