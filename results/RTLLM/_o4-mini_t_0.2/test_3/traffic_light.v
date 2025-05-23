module traffic_light
    (
      input            rst_n,         // active‐low reset
      input            clk,           // system clock
      input            pass_request,  // pedestrian/vehicle pass request
      output wire [7:0] clock,        // current countdown value
      output reg       red,           // red light
      output reg       yellow,        // yellow light
      output reg       green          // green light
    );

  // state encoding
  parameter idle     = 2'd0,
            s1_red   = 2'd1,
            s2_yellow= 2'd2,
            s3_green = 2'd3;

  reg [1:0]  state, next_state;
  reg [7:0]  cnt;
  reg        p_red, p_yellow, p_green;

  //============================================================================
  // 1) Combinational next‐state logic and next‐output (p_*) logic
  //============================================================================
  always @(*) begin
    next_state = state;
    p_red      = 1'b0;
    p_yellow   = 1'b0;
    p_green    = 1'b0;

    case (state)
      idle: begin
        // on reset we go immediately to RED
        next_state = s1_red;
      end

      s1_red: begin
        p_red = 1'b1;
        if (cnt == 8'd0)
          next_state = s3_green;
      end

      s3_green: begin
        p_green = 1'b1;
        if (cnt == 8'd0)
          next_state = s2_yellow;
      end

      s2_yellow: begin
        p_yellow = 1'b1;
        if (cnt == 8'd0)
          next_state = s1_red;
      end

      default: begin
        next_state = idle;
      end
    endcase
  end

  //============================================================================
  // 2) Sequential block: update state and outputs red/yellow/green
  //============================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state  <= idle;
      red    <= 1'b0;
      yellow <= 1'b0;
      green  <= 1'b0;
    end else begin
      state  <= next_state;
      red    <= p_red;
      yellow <= p_yellow;
      green  <= p_green;
    end
  end

  //============================================================================
  // 3) Sequential block: counter management
  //    - On entering a new state (state != next_state) we reload the counter
  //    - In green state, if pass_request arrives and we have >10 clocks left,
  //      shorten to 10
  //    - Otherwise decrement until zero
  //============================================================================
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt <= 8'd0;
    end else if (state != next_state) begin
      // just entered a new state => reload the counter
      case (next_state)
        s1_red:    cnt <= 8'd10;   // red for 10 clocks
        s2_yellow: cnt <= 8'd5;    // yellow for 5 clocks
        s3_green:  cnt <= 8'd60;   // green for 60 clocks
        default:   cnt <= 8'd0;
      endcase
    end else if (state == s3_green && pass_request && cnt > 8'd10) begin
      // shorten remaining green to 10 if request and more than 10 left
      cnt <= 8'd10;
    end else if (cnt > 8'd0) begin
      // normal countdown
      cnt <= cnt - 8'd1;
    end
  end

  //============================================================================
  // expose the counter
  //============================================================================
  assign clock = cnt;

endmodule