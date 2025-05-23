module width_8to16(
    input                       clk        ,   
    input                       rst_n      ,
    input                       valid_in   ,
    input   [7:0]               data_in    ,
    output   reg                valid_out  ,
    output   reg [15:0]         data_out
);
    // Internal signals
    reg [7:0]                   data_lock;
    reg                         flag;

    // On reset, clear the data_out and valid_out signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
        end else if (flag) begin
            // Concatenate the locked data and the current data_in
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

    // Process the valid_in signal and handle the data_lock and flag signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock <= 8'b0;
            flag <= 1'b0;
        end else if (valid_in) begin
            if (flag) begin
                // If flag is set, store the current data_in in data_lock and clear the flag
                data_lock <= data_in;
                flag <= 1'b0;
            end else begin
                // If flag is not set, store the current data_in in data_lock and set the flag
                data_lock <= data_in;
                flag <= 1'b1;
            end
        end
    end
endmodule