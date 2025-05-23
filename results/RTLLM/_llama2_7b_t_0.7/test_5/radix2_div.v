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

// Module parameters
parameter DIVISOR_WIDTH = 8; // Width of the divisor register
parameter QUOTIENT_WIDTH = 8; // Width of the quotient register
parameter REMAINDER_WIDTH = 8; // Width of the remainder register
parameter SIGNED_OPERATIONS = 1; // Flag for signed operations

// Module signals
wire [7:0] dividend; // Dividend input signal
wire [7:0] divisor; // Divisor input signal
wire sign; // Sign flag for signed division (1 for signed, 0 for unsigned)
wire opn_valid; // Output ready signal for operation request
wire res_valid; // Validity signal for the result output
wire [15:0] result; // Result output signal

// Module constants
constants CNTR_WIDTH = DIVISOR_WIDTH - 1; // Width of the counter register
constants START_CNT = CNTR_WIDTH - 1; // Value of the start counter
constants MAX_CNT = CNTR_WIDTH * 2 + 1; // Maximum value of the counter

// Module inputs and outputs
input wire clk; // Clock signal
input wire rst; // Reset signal
input wire sign; // Sign flag for signed division (1 for signed, 0 for unsigned)
input wire [7:0] dividend; // Dividend input signal
input wire [7:0] divisor; // Divisor input signal
input wire opn_valid; // Output ready signal for operation request
output reg res_valid; // Validity signal for the result output
input wire res_ready; // Ready signal for the result output
output wire [15:0] result; // Result output signal

// Module logic
always @* begin
    // Division process
    if (opn_valid && res_valid) begin
        // Save inputs
        dividend <= {dividend, sign};
        divisor <= {divisor, sign};
        
        // Initialize shift register SR with absolute value of dividend shifted left by one bit
        SR <= {~dividend[0], ~dividend[1], ..., ~dividend[7]};
        
        // Set NEG_DIVISOR to the negated absolute value of the divisor
        NEG_DIVISOR <= -divisor;
        
        // Set start counter to 1 and clear cnt and start_cnt
        cnt <= 1;
        start_cnt <= 1;
        
        // Perform division
        while (start_cnt) begin
            // If counter cnt reaches 8, the division is complete
            if (CNTR_WIDTH == 0) begin
                // Clear cnt and start_cnt
                cnt <= 0;
                start_cnt <= 0;
                
                // Update shift register SR with final remainder and quotient
                SR <= {~SR[7:1], ~SR[0]};
            end else begin
                // Increment counter cnt
                cnt <= cnt + 1;
                
                // Update shift register SR based on subtraction result
                SR <= {SR[7:1] - NEG_DIVISOR, SR[0]};
            end
        end
        
        // Set res_valid to 1 when the division is complete
        res_valid <= 1;
    end else begin
        // Reset res_valid and cnt to 0
        res_valid <= 0;
        cnt <= 0;
    end
end

// Assign output ready signal
always @* begin
    if (opn_valid && res_ready) begin
        res_valid <= 1;
    end else begin
        res_valid <= 0;
    end
end

// Generate output result
always @* begin
    if (res_valid) begin
        result <= SR;
    end else begin
        result <= 0;
    end
end