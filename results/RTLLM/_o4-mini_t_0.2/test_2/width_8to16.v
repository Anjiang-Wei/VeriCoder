module width_8to16 (
    input              clk,
    input              rst_n,
    input              valid_in,
    input      [7:0]   data_in,
    output reg         valid_out,
    output reg [15:0]  data_out
);

    // internal registers
    reg        flag;            // indicates we have stored the first byte
    reg        produce;         // pulses to generate valid_out/data_out next cycle
    reg [7:0]  data_lock;       // holds the first 8‐bit word
    reg [15:0] next_data_out;   // holds the concatenated result until output

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            flag          <= 1'b0;
            produce       <= 1'b0;
            data_lock     <= 8'd0;
            next_data_out <= 16'd0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            // 1) Drive outputs from the previous produce pulse
            valid_out <= produce;
            if (produce)
                data_out <= next_data_out;

            // 2) Default clear of produce (will be set again if we see a 2nd byte)
            produce <= 1'b0;

            // 3) Handle incoming bytes
            if (valid_in) begin
                if (!flag) begin
                    // first byte arrives: store it, set flag
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end else begin
                    // second byte arrives: form 16‐bit word, schedule output next cycle
                    next_data_out <= {data_lock, data_in};
                    produce       <= 1'b1;
                    flag          <= 1'b0;
                end
            end
        end
    end

endmodule