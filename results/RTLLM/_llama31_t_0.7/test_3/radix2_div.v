module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

// Internal registers
reg signed [8:0] SR; // Shift Register
reg signed [8:0] NEG_DIVISOR;
reg [7:0] cnt; // Counter
reg start_cnt; // Start Count Flag

// Internal flags
reg res_initialized = 1'b0; // Result initialized flag
reg division_complete = 1'b0; // Division complete flag
reg [1:0] state = 2'b00; // State machine for the division process

// Internal signals
wire signed [8:0] subtraction_result;
wire signed [8:0] updated_SR;

always @ (posedge clk) begin
    if (rst) begin
        SR <= 'd0;
        NEG_DIVISOR <= 'd0;
        cnt <= 'd0;
        start_cnt <= 'd0;
        res_initialized <= 1'b0;
        division_complete <= 1'b0;
        state <= 2'b00;
    end else if (opn_valid) begin
        // Operation Start
        if (!res_valid && !res_ready) begin
            SR <= {dividend[7], dividend};
            NEG_DIVISOR <= -divisor;
            cnt <= 'd1;
            start_cnt <= 1'b1;
            res_initialized <= 1'b1;
            division_complete <= 1'b0;
        end else if (start_cnt) begin
            // Division Process
            case (state)
                2'b00: begin
                    // Initial state
                    subtraction_result <= SR - NEG_DIVISOR;
                    updated_SR <= {SR[8], subtraction_result[7]} << 1 | subtraction_result[0];
                    cnt <= cnt + 1;
                    if (cnt == 'd8) begin
                        division_complete <= 1'b1;
                    end else begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    // Update shift register based on subtraction result
                    updated_SR <= {SR[8], subtraction_result[7]} << 1 | subtraction_result[0];
                    SR <= updated_SR;
                    cnt <= cnt + 1;
                    if (cnt == 'd8) begin
                        division_complete <= 1'b1;
                    end else begin
                        state <= 2'b10;
                    end
                end
                default: begin
                    $error("Invalid state");
                end
            endcase
        end

        // Result Validity
        if (division_complete && res_initialized) begin
            result[7:0] <= updated_SR[8:1];
            result[15:8] <= SR[8:1];
            res_valid <= 1'b1;
        else if (!res_ready) begin
            $error("Error: Result not ready");
        end

    end
end

endmodule