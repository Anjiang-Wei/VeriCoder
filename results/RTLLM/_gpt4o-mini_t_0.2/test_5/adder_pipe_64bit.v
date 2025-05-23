module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Internal registers for pipelining
reg [DATA_WIDTH-1:0] reg_a, reg_b;
reg [DATA_WIDTH:0] sum_stage1, sum_stage2;

// Pipeline state machine signals
reg [1:0] state;
localparam IDLE = 2'b00,
           STAGE1 = 2'b01,
           STAGE2 = 2'b10;

// Always block for synchronous behavior and reset handling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_a <= 0;
        reg_b <= 0;
        sum_stage1 <= 0;
        sum_stage2 <= 0;
        o_en <= 0;
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (i_en) begin
                    // Load inputs into registers
                    reg_a <= adda;
                    reg_b <= addb;
                    state <= STAGE1;
                end
            end
            
            STAGE1: begin
                // Perform first stage of addition
                sum_stage1 <= reg_a + reg_b;
                state <= STAGE2;
            end
            
            STAGE2: begin
                // Assign final result and output valid signal
                result <= sum_stage1; // final result 
                o_en <= 1; // output is valid
                // Reset to IDLE after the result is read
                state <= IDLE;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule