module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [1:0] cnt;
reg [3:0] data;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        valid_out <= 1'b0;
        dout <= 1'b0;
        data <= 4'b0000;
    end else begin
        if (cnt == 2'b11) begin
            valid_out <= 1'b1;
            dout <= data[3];
            data <= d;
            cnt <= 2'b00;
        end else begin
            valid_out <= 1'b0;
            cnt <= cnt + 2'b01;
            dout <= data[cnt];
            data <= data << 1;
        end
    end
end

endmodule