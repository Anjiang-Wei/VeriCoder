```verilog
    reg [3:0] data;
    reg [1:0] cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            data <= 4'b0;
            cnt <= 2'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end
        else begin
            if(cnt == 2'b11) begin
                data <= d;
                cnt <= 2'b0;
                valid_out <= 1'b1;
                dout <= data[3];
            end
            else begin
                cnt <= cnt + 1;
                valid_out <= 1'b0;
                dout <= data[0];
                data <= {data[2:0], d[3]};
            end
        end
    end
endmodule