module parallel2serial(
    input  clk,         // Clock signal used for synchronous operations.
    input  rst_n,       // Reset signal. Defined as 0 for reset and 1 for reset signal inactive.
    input  [3:0] d,     // 4-bit parallel data input.
    output valid_out,   // Valid signal indicating the availability of serial output.
    output dout         // Serial output representing the converted data.
);

// Internal registers
reg [2:0] cnt;         // Counter to track bits in each cycle
reg [3:0] data;        // Data register for storing parallel input

always @(posedge clk) begin
  if (!rst_n) begin
    cnt <= 1;
  end else begin
    case (cnt)
      3'd3: begin
        valid_out <= 1'b1;
        dout <= data[0];
        cnt <= 'd0;
        data <= d;
      end
      default: begin
        cnt <= cnt + 1;
        if (!valid_out) begin
          data <= {data[2], data[1], data[0]};
          valid_out <= 1'b0;
        end
      end
    endcase
  end
end

endmodule