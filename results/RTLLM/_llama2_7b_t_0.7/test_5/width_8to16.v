module width_8to16(
    input  clk,
    input rst_n,
    input valid_in,
    input data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

always@(posedge clk or negedge rst_n) begin
    // Reset the data_out register on reset
    if (!rst_n) begin
        data_out <= 0;
    end else begin
        // Update the data_out register with the concatenation of the data_in and data_lock registers
        if (valid_in && valid_in[7]) begin
            data_out <= data_in + data_lock;
        end
    end
end