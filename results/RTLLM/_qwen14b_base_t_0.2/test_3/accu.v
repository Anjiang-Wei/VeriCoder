module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    // Internal signals and variables
    reg [7:0] data_reg [3:0]; // Register to hold the last 4 data_in values
    reg [9:0] sum;            // 10-bit register to hold the sum of the last 4 data_in values
    reg [1:0] count;          // Counter to keep track of the number of valid inputs received

    // Initialize internal registers
    initial begin
        count <= 0;
        sum <= 0;
        valid_out <= 0;
    end

    // Synchronous reset and clock process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            sum <= 0;
            valid_out <= 0;
            data_out <= 0;
            data_reg[0] <= 0;
            data_reg[1] <= 0;
            data_reg[2] <= 0;
            data_reg[3] <= 0;
        end else begin
            // Shift data into the register array
            if (valid_in) begin
                data_reg[3] <= data_reg[2];
                data_reg[2] <= data_reg[1];
                data_reg[1] <= data_reg[0];
                data_reg[0] <= data_in;
                count <= count + 1;
            end

            // Calculate the sum of the last 4 valid inputs
            if (count == 4) begin
                sum <= data_reg[0] + data_reg[1] + data_reg[2] + data_reg[3];
                valid_out <= 1;
                data_out <= sum;
                count <= 0; // Reset the counter after outputting the sum
            end else if (count == 1) begin
                sum <= data_reg[0];
            end else if (count == 2) begin
                sum <= sum + data_reg[1];
            end else if (count == 3) begin
                sum <= sum + data_reg[2];
            end

            // Deassert valid_out after one cycle
            if (valid_out) begin
                valid_out <= 0;
            end
        end
    end
endmodule