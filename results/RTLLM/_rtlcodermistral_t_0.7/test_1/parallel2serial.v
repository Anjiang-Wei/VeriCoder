```verilog
    reg [3:0] data;
    reg [1:0] cnt;
    assign valid_out = cnt == 2'b11;
    assign dout = data[3];
    
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            data <= 0;
            cnt <= 0;
        end
        else begin
            if(cnt == 2'b11) begin
                data <= d;
                cnt <= 0;
            end
            else begin
                cnt <= cnt + 1;
                data <= {data[2:0], d[3]};
            end
        end
    end
endmodule