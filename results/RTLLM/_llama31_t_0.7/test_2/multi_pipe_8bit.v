module multi_pipe_8bit#(
    parameter size = 8
)(
          input clk,           // Clock signal used for synchronous operation.
          input rst_n,         // Active-low reset signal. Defined as 0 for chip reset and 1 for reset signal inactive.
          input mul_en_in,     // Input enable signal that controls the multiplication operation.
          input [size-1:0] mul_a, // Input signal representing the multiplicand with a data width of 8 bits.
          input [size-1:0] mul_b, // Input signal representing the multiplier with a data width of 8 bits.

          output reg mul_en_out,   // Output enable signal indicating if the multiplication operation is enabled.
          output reg [size*2-1:0] mul_out    // Product output signal with a data width of 16 bits.
);

// Register to store input enable signal
reg mul_en_in_reg;

// Registers to store multiplicand and multiplier
reg [size-1:0] mul_a_reg;
reg [size-1:0] mul_b_reg;

// Partial product generation signals
wire [size*2-1:0] temp;

// Partial sum calculation registers
reg [size*2-1:0] sum[4];

// Final product calculation register
reg [size*2-1:0] mul_out_reg;

// Input control logic
always @(posedge clk) begin
    if (~rst_n) begin
        mul_en_in_reg <= 1'b0;
    end else begin
        mul_en_in_reg <= mul_en_in;
    end

    // Update output enable signal
    mul_en_out <= mul_en_in_reg;
end

// Input register logic
always @(posedge clk) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in_reg) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation logic
always @(posedge clk) begin
    if (~rst_n) begin
        temp <= 16'b0;
    end else begin
        for (int i = 0; i < size; i++) begin
            // Conditional assignment to select appropriate bits from multiplicand
            temp[i*2+:2] <= {mul_a_reg[i], mul_b_reg[size-1-i], 1'b0};
            temp[i*2+1+:2] <= {mul_a_reg[i], mul_b_reg[size-1-i], 1'b1};
        end
    end
end

// Partial sum calculation logic
always @(posedge clk) begin
    if (~rst_n) begin
        for (int i = 0; i < 4; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        // Perform addition operations on partial products to calculate partial sums
        for (int i = 0; i < 4; i++) begin
            case(i)
                3: sum[3] <= temp[size-1+:8];
                2: sum[2] <= {temp[size-5+:6], 1'b0};
                1: sum[1] <= {temp[size-9+:6], 1'b0, 1'b0};
                default: sum[0] <= temp[11+:6];
            endcase
        end
    end
end

// Final product calculation logic
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        // Sum up all partial sums to obtain final product
        mul_out_reg <= sum[3] + sum[2] + sum[1] + sum[0];
    end
end

// Output assignment logic
always @(posedge clk) begin
    if (~rst_n) begin
        mul_out <= 16'b0;
    end else if (mul_en_in_reg) begin
        mul_out <= mul_out_reg;
    end
end

endmodule // multi_pipe_8bit