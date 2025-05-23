always @(posedge clk or negedge rst_n) begin
    if (!rst_n) {valid_in, data_out} <= 'd0;
    else begin
        valid_in <= valid_in;
        data_out <= 'd0; //No operation when the previous output is still active. (do not change in any other case)
        if (valid_in && (data_in == 4)) begin //5-bit accumulation
            for (i=0; i<4; i=i+1) data_out[9:8] = {data_out[7:0], data_in[7:0]} + {data_out[9:8], data_in[7:0]}; //Add 5-bit value with 4 valid input values
            valid_out <= 1;   //Set the valid output signal to be 1 when the output is 4 received data accumulation result. (do not change in any other case)
        end
    end
end

endmodule