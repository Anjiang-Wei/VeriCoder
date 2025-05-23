module freq_div (
    input  wire           CLK_in,
    input  wire           RST,
    output reg            CLK_50,
    output reg            CLK_10,
    output reg            CLK_1
);

reg [9:0] cnt_100; // Counter for CLK_1 generation (49 cycles)
reg [2:0] cnt_10;  // Counter for CLK_10 generation (4 cycles)
reg        tmp_50;  // Temporary signal for CLK_50 generation

// Initialize signals on reset
always @(posedge RST or posedge CLK_in) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
        cnt_100 <= 'b0;
        cnt_10  <= 'b0;
    end
end

// Generate CLK_50 signal (frequency divided by 2)
always @(posedge RST or posedge CLK_in) begin
    if (RST) begin
        tmp_50 <= 1'b0;
    end else begin
        tmp_50 <= ~tmp_50; // Toggle on every positive edge of CLK_in
    end

    // Assign output signal
    CLK_50 <= tmp_50;
end

// Generate CLK_10 signal (frequency divided by 10)
always @(posedge RST or posedge CLK_in) begin
    if (RST) begin
        cnt_10 <= 'b0; // Reset counter on reset
        CLK_10 <= 1'b0;
    end else begin
        if (cnt_10 == 3'd4) begin // Counter reaches value of 4
            cnt_10 <= 'b0; // Reset counter
            CLK_10 <= ~CLK_10; // Toggle output signal
        end else begin
            cnt_10 <= cnt_10 + 1'b1; // Increment counter
        end
    end

    // Assign output signal
    CLK_10 <= (cnt_10 == 3'd4) ? ~CLK_10 : CLK_10;
end

// Generate CLK_1 signal (frequency divided by 100)
always @(posedge RST or posedge CLK_in) begin
    if (RST) begin
        cnt_100 <= 'b0; // Reset counter on reset
        CLK_1  <= 1'b0;
    end else begin
        if (cnt_100 == 9'd49) begin // Counter reaches value of 49
            cnt_100 <= 'b0; // Reset counter
            CLK_1  <= ~CLK_1; // Toggle output signal
        end else begin
            cnt_100 <= cnt_100 + 1'b1; // Increment counter
        end
    end

    // Assign output signal
    CLK_1 <= (cnt_100 == 9'd49) ? ~CLK_1 : CLK_1;
end
endmodule