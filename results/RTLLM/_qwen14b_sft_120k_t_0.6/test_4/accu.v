module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    reg [7:0] data_reg [3:0];  // Register to hold 4 data inputs
    reg [9:0] sum;            // Accumulated sum of 4 data inputs

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg[0] <= 8'b0;
            data_reg[1] <= 8'b0;
            data_reg[2] <= 8'b0;
            data_reg[3] <= 8'b0;
            sum <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else if (valid_in) begin
            // Shift data into the register array
            data_reg[3] <= data_reg[2];
            data_reg[2] <= data_reg[1];
            data_reg[1] <= data_reg[0];
            data_reg[0] <= data_in;
            // Calculate the sum of the 4 data inputs
            sum <= sum + data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
            valid_out <= 1'b1;
            data_out <= sum;
            // Set valid_out to 0 after 1 cycle
            valid_out <= 1'b0;
        end
    end

endmodule