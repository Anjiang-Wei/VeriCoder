module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

  // State encoding
  localparam IDLE = 2'b00,  // waiting for data_in to become 1
             RISE = 2'b01;  // data_in has gone high; waiting for it to fall again

  reg [1:0] state;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state    <= IDLE;
      data_out <= 1'b0;
    end
    else begin
      case (state)
        IDLE: begin
          data_out <= 1'b0;      // clear output unless pulse detected
          if (data_in)          // rising edge detected
            state <= RISE;
          else
            state <= IDLE;
        end

        RISE: begin
          if (!data_in) begin  // falling edge: pulse from 0->1->0 complete
            data_out <= 1'b1;  // Assert pulse detection
            state <= IDLE;     // Return to idle for next pulse
          end
          else begin           // remain in RISE state if data_in stays high
            data_out <= 1'b0;
            state <= RISE;
          end
        end

        default: begin
          state <= IDLE;
          data_out <= 1'b0;
        end
      endcase
    end
  end
 
endmodule