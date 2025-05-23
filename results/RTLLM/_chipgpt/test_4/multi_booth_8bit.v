module multi_booth_8bit (p, rdy, clk, reset, a, b);
   input clk, reset;
   input [7:0] a, b;
   output [15:0] p;
   output rdy;

    // Fixed point multiplier with 16 x 8-bit registers.
wire[15:0] m_prod;
   assign m_prod = {{8{a[7]}}, a} * {{8{b[7]}}, b};

   // Booth multiplier with 24 x 8-bit registers.
wire[3:0] m_c0;
wire[15:0] m_prod16;
    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            m_c0 <= 8'd0;
        else
            m_c0 <= m_c0 <{15, {m_prod[23:0]}} ? m_c0 + 8'd1 : m_c0; // shift left operation
    end

   wire[3:0] m_c4 = m_c0 << 4;
   wire[3:0] m_c8 = m_c0 << 8;
   wire[3:0] m_cd = m_c0 << 12;
   
   assign p[7:0] = (m_prod == m_prod16) ? m_cd : m_cd + {m_prod[15:8], m_c8}; // add operation

   wire rdy_nxt;
   always @(posedge clk or posedge reset) begin
        if (reset == 1'b1)
            rdy_nxt <= 1'b0;
        else if (m_prod[15:8] == m_prod16)
            rdy_nxt <= 1'b1;
        else
            rdy_nxt <= 1'b0;
   end

   assign rdy = rdy_nxt;

endmodule