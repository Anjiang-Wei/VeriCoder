module width_8to16(
    input         clk,
    input         rst_n,
    input         valid_in,
    input [7:0]   data_in,
    
    output reg    valid_out,
    output reg [15:0] data_out
);

  // Define state encoding
  localparam STATE_IDLE = 2'b00,  // waiting for the first valid data
             STATE_WAIT = 2'b01,  // first data stored; waiting for second valid data
             STATE_OUT  = 2'b10;  // ready to output concatenated data in next cycle
  
  reg [1:0] state;
  reg [7:0] data_lock;    // to store the first valid data
  reg [7:0] temp_data;    // to store the second valid data

  // Synchronous state machine with asynchronous reset
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state      <= STATE_IDLE;
      data_lock  <= 8'd0;
      temp_data  <= 8'd0;
      valid_out  <= 1'b0;
      data_out   <= 16'd0;
    end
    else begin
      case (state)
        STATE_IDLE: begin
          valid_out <= 1'b0;    // no output yet
          data_out  <= 16'd0;
          if (valid_in) begin
            data_lock <= data_in;  // latch the first data item
            state <= STATE_WAIT;
          end
          else begin
            state <= STATE_IDLE;
          end
        end

        STATE_WAIT: begin
          valid_out <= 1'b0;
          data_out  <= 16'd0;
          if (valid_in) begin
            temp_data <= data_in;  // latch the second data item
            state <= STATE_OUT;
          end
          else begin
            state <= STATE_WAIT;
          end
        end

        STATE_OUT: begin
          // On the cycle after two valid data inputs, produce a valid output.
          valid_out <= 1'b1;
          data_out  <= {data_lock, temp_data};  // concatenation: first data in high 8 bits
          state <= STATE_IDLE;  // return to idle to process the next pair
        end

        default: state <= STATE_IDLE;
      endcase
    end
  end

endmodule