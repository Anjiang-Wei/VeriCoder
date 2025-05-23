module top_module(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg [15:0] data_out,
    output reg valid_out
);

reg [7:0] data_lock;
reg flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 0;
        valid_out <= 0;
        data_lock <= 0;
        flag <= 0;
    end else begin
        if (valid_in) begin
            if (flag) begin
                data_out <= {data_lock, data_in};
                valid_out <= 1;
                flag <= 0;
            end else begin
                data_lock <= data_in;
                flag <= 1;
            end
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule