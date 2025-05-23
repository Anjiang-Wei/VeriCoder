module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

reg [31:0] acc; // Accumulator register (32 bits)
reg [3:0] count; // Counter for four accumulations

always @(posedge clk) begin
    if (~rst_n) begin
        acc <= '0;
        valid_out <= 1'b0;
        data_out <= '0;
        count <= '0;
    end else begin
        if (valid_in) begin
            acc <= acc + {{24{data_in[7]}}, data_in};
            count <= count + 1;
            if (count == 4'd4) begin
                valid_out <= 1'b1;
                data_out <= {acc[9:0], 10'h0}; // Output last four accumulations
                acc <= '0; // Reset accumulator
                count <= '0; // Reset counter
            end
        end else if (count > 4'd0) begin
            valid_out <= 1'b0;
            data_out <= {acc[9:0], 10'h0};
            acc <= '0; // Reset accumulator
            count <= '0; // Reset counter
        end
    end
end

endmodule