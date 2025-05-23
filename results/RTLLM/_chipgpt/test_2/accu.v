always@(posedge clk or negedge rst_n)
    if(!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 0;
    end
    else begin
        
            if (valid_in) begin //valid_in will be set to 1 before the first input comes in
                case({data_in,valid_in})
                2'b01: begin //when the valid_in is 1 and data_in is 4-bit(hexadecimal "35"), it means that last four received data are accumulated
                        data_out <= data_out + {data_in[7:8], data_in[0:3]};
                    end
                default: begin //else, the last four input data is not used as a whole(since there is no "4" in the hexadecimal "01"), but rather just one by one 
                        if (valid_out) data_out <= data_out; //when valid_out=1, it means that 4 received data are accumulated. So when the current input(which is not "4") is used as a whole to calculate sum, valid_out must be set to 1
                        else data_out <= data_out + {data_in[7:8], data_in[0:3]}; //else, just accumulate one by one and it will keep on doing so until the "4" comes in. After which valid_out must be set to 1 again
                    end
                endcase
            end
        end
    valid_out <= valid_in;
end