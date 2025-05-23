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

    // Internal signals
    reg [15:0] SR; // Shift register
    reg [7:0] NEG_DIVISOR; // Negated divisor
    reg [3:0] cnt; // Counter
    reg start_cnt; // Start counter
    wire carry_out; // Carry out from subtraction

    // Assign output
    assign result = SR;

    // Initializations
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 0;
            NEG_DIVISOR <= 0;
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Save inputs and initialize
                SR <= {1'b0, dividend} << 1; // Shift dividend left by 1
                NEG_DIVISOR <= ~divisor + 1'b1; // Negated divisor
                cnt <= 1;
                start_cnt <= 1;
            end else if (res_ready && res_valid) begin
                // Reset for next operation
                res_valid <= 0;
            end
            if (start_cnt) begin
                // Division process
                if (cnt == 8) begin
                    // Division complete
                    start_cnt <= 0;
                    cnt <= 0;
                    SR <= {SR[15:8], SR[7:0]}; // Update SR with remainder and quotient
                end else begin
                    // Increment counter and update SR
                    cnt <= cnt + 1;
                    SR <= {carry_out, SR[15:1]}; // Shift left and insert carry-out
                end
            end
        end
    end

    // Subtraction logic
    assign carry_out = (SR[15:8] >= NEG_DIVISOR);
    assign SR[15:8] = (carry_out) ? (SR[15:8] - NEG_DIVISOR) : (SR[15:8]);

    // Manage res_valid
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
        end else begin
            if (cnt == 8 && start_cnt) begin
                res_valid <= 1;
            end else if (res_ready && res_valid) begin
                res_valid <= 0;
            end
        end
    end

    // Handle sign
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Do nothing
        end else begin
            if (sign && (dividend[7] ^ divisor[7])) begin
                // If signed and signs are different, negate the result
                SR <= ~SR + 1'b1;
            end
        end
    end

endmodule