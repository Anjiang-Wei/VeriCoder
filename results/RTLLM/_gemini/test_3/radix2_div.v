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
    reg [7:0] abs_dividend; // Absolute value of dividend
    reg [7:0] abs_divisor; // Absolute value of divisor
    wire carry_out; // Carry out from subtraction

    // Assign output
    assign result = SR;

    // Calculate absolute values
    assign abs_dividend = sign ? (dividend[7] ? ~dividend + 1'b1 : dividend) : dividend;
    assign abs_divisor = sign ? (divisor[7] ? ~divisor + 1'b1 : divisor) : divisor;

    // Calculate negated divisor
    assign NEG_DIVISOR = ~abs_divisor + 1'b1;

    // Subtraction logic
    assign carry_out = SR[15:8] >= NEG_DIVISOR;

    // Multiplexer for result selection
    assign SR[15:8] = carry_out ? SR[15:8] - NEG_DIVISOR : SR[15:8];

    // Update shift register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR <= {abs_dividend, 1'b0}; // Initialize SR with dividend shifted left
                NEG_DIVISOR <= ~abs_divisor + 1'b1; // Calculate negated divisor
                cnt <= 4'b1; // Initialize counter
                start_cnt <= 1'b1; // Start division process
            end else if (start_cnt) begin
                if (cnt == 4'b1111) begin // Division complete
                    cnt <= 4'b0;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1; // Increment counter
                    SR <= {carry_out, SR[15:1]}; // Shift SR left and insert carry-out
                end
            end else if (res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Handle sign of the result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Do nothing
        end else begin
            if (sign && (dividend[7] ^ divisor[7])) begin
                SR[15:8] <= ~SR[15:8] + 1'b1; // Negate remainder
                SR[7:0] <= ~SR[7:0] + 1'b1; // Negate quotient
            end
        end
    end

endmodule