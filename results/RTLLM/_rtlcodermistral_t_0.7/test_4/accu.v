```verilog
    reg [7:0] data_reg [0:3];
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_out <= 0;
            data_out <= 0;
            count <= 0;
            for (int i = 0; i < 4; i = i + 1) begin
                data_reg[i] <= 0;
            end
        end
        else begin
            if (valid_in) begin
                data_reg[count] <= data_in;
                count <= count + 1;
                if (count == 4) begin
                    valid_out <= 1;
                    data_out <= {1'b0, data_reg[0]} + {1'b0, data_reg[1]} + {1'b0, data_reg[2]} + {1'b0, data_reg[3]};
                    count <= 0;
                end
            end
        end
    end
endmodule