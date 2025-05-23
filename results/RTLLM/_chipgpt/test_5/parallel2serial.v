module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg cnt; //counter for 4-bit parallel input to get serial output of one bit
reg [2:0] data; //data register
reg zero = !rst_n; //if the signal is 1 then it means reset and if its zero then it indicates not active
always @(posedge clk)
    if (zero) cnt <= 0;
    else ctn <= cnt+1;

assign valid_out = cnt==4?0:1; //if counter is 0, then means that we have 4 bits and hence the last bit will be output as a serial bit
always @*
    if (zero) begin //if the signal rst_n is one then it means active reset and when its zero then it indicates not active
        data <= d;//data register initialised with parallel input
    end
    else begin
        if (valid_out) begin //if valid_out is one, then it means that we have a serial bit and hence the most significant bit will be output as a dout
            dout <= data[3];
            data <= data[2:0]; 
        end
        else begin
            data <= data<<1; //if valid_out is zero, then it means that we dont have a serial bit and hence we shift the data register one bit to the left(from the most significant bit to least significant bit)
        end
    end
endmodule