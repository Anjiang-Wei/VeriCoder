module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
) ;

// Define the counter register
localparam CNT_WIDTH = 4;
reg [CNT_WIDTH-1:0] cnt = 0;

// Define the data register
localparam DATA_WIDTH = 4;
reg [DATA_WIDTH-1:0] data = {d[3], d[2], d[1], d[0]} ;

// Logic to update the data register and set valid output
always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        cnt <= 0;
        data <= {d[3], d[2], d[1], d[0]} ;
        valid_out <= 0;
    end else begin
        // Check if we have reached the last bit of the parallel input
        if (cnt == 3) begin
            cnt <= 0;
            data <= {d[3], d[2], d[1], d[0]} ;
            valid_out <= 1;
        // Otherwise, increment the counter and shift the data register
        } else begin
            cnt <= cnt + 1;
            data <= data [DATA_WIDTH-1:0] :> (data [3]) ;
            valid_out <= 0;
        end
    end
end

// Output the serial output
always @* begin
    case (valid_out)
        1'b0: dout <= data [3];
        1'b1: dout <= {data [2], data [1], data [0]} ;
    endcase
end