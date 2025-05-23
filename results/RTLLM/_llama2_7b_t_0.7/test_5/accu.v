module accu(
    input               clk         ,
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// Define the state machine variables
localparam T = 1; // Time period (cycle)
localparam N = 4; // Number of input data to accumulate

// Define the state machine states
typedef enum {IDLE, ACCUMULATING} state_t;

// Define the state machine transition table
always @(*) begin
    case (state_t)
        IDLE: begin
            // Reset the valid output and data output when reset is asserted
            valid_out <= 0;
            data_out <= 0;
            
            // Wait for the next clock cycle
            #T;
        end
        ACCUMULATING: begin
            // Check if there are enough input data to accumulate
            if (valid_in) begin
                // Accumulate the input data and update the output
                data_out <= data_out + data_in;
                
                // Reset the valid output when the accumulation is complete
                valid_out <= 0;
            end else begin
                // Wait for the next clock cycle
                #T;
            end
        end
    endcase
end

endmodule