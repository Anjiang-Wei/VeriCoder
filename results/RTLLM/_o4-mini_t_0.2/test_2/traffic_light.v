module traffic_light
  (
    input            rst_n,        // active‐low reset
    input            clk,          // system clock
    input            pass_request, // pedestrian button
    output wire [7:0] clock,       // current count value
    output reg       red,          // lane red light
    output reg       yellow,       // lane yellow light
    output reg       green         // lane green light
  );

  // FSM state encoding
  parameter idle     = 2'd0,
            s1_red   = 2'd1,
            s2_yellow= 2'd2,
            s3_green = 2'd3;

  reg [1:0] state, next_state;
  reg       p_red, p_yellow, p_green;
  reg [7:0] cnt;

  //==========================================================================
  // 1) Combinational next‐state & output‐precompute
  //==========================================================================
  always @(*) begin
    // defaults
    next_state = state;
    p_red      = 1'b0;
    p_yellow   = 1'b0;
    p_green    = 1'b0;

    case(state)
      idle: begin
        // immediately go to RED phase
        next_state = s1_red;
      end

      s1_red: begin
        p_red = 1'b1;
        // when counter expires → GREEN
        if (cnt == 8'd0)
          next_state = s3_green;
        else
          next_state = s1_red;
      end

      s3_green: begin
        p_green = 1'b1;
        // when counter expires → YELLOW
        if (cnt == 8'd0)
          next_state = s2_yellow;
        else
          next_state = s3_green;
      end

      s2_yellow: begin
        p_yellow = 1'b1;
        // when counter expires → RED
        if (cnt == 8'd0)
          next_state = s1_red;
        else
          next_state = s2_yellow;
      end

      default: begin
        next_state = idle;
      end
    endcase
  end

  //==========================================================================
  // 2) Sequential: state register update
  //==========================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= idle;
    else
      state <= next_state;
  end

  //==========================================================================
  // 3) Sequential: down‐counter with phase‐entry reload and pass_request logic
  //==========================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt <= 8'd0;
    end else begin
      // on entering RED phase
      if (state != s1_red && next_state == s1_red) begin
        cnt <= 8'd10;      // 10 cycles of RED

      // on entering GREEN phase
      end else if (state != s3_green && next_state == s3_green) begin
        cnt <= 8'd60;      // 60 cycles of GREEN

      // on entering YELLOW phase
      end else if (state != s2_yellow && next_state == s2_yellow) begin
        cnt <= 8'd5;       // 5 cycles of YELLOW

      // shorten GREEN if pass_request and >10 remaining
      end else if (state == s3_green && pass_request && cnt > 8'd10) begin
        cnt <= 8'd10;

      // normal countdown
      end else if (cnt != 8'd0) begin
        cnt <= cnt - 8'd1;

      // hold at zero
      end else begin
        cnt <= 8'd0;
      end
    end
  end

  // expose the counter
  assign clock = cnt;

  //==========================================================================
  // 4) Sequential: register the outputs from the precompute values
  //==========================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      red    <= 1'b0;
      yellow <= 1'b0;
      green  <= 1'b0;
    end else begin
      red    <= p_red;
      yellow <= p_yellow;
      green  <= p_green;
    end
  end

endmodule