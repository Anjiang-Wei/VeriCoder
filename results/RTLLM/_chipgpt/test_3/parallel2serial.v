module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output reg[7:0] data,
    output reg cnt,
    output reg valid
);

initial begin
    cnt = 0;
    valid = 1;
end
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 8'hff;
        cnt <= 0;
        valid <= 1;
    end
    else begin
        if (cnt == 3) begin
            data <= d;
            cyt <= 0;
            valid <= 1;
        end
        else begin
            cyt <= cyt + 1;
            valid <= 0;
        end
    end
end
endmodule