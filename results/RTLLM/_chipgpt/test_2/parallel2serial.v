wire cnt;
reg [1:0] data;
parameter C = 2'd4,
          E = 2'd8,
          H = 2'd16;
always @(posedge clk or negedge rst_n)
    if (~rst_n) data <= {E{1'b0}};
    else if (cnt == E) data <= {H{data[1]}, data[2:0]};
    else if (cnt == H) data <= {C{data[3]}, data[4:0]};
    else if (cnt == C) data <= {E{data[5]}, data[6:0]};
    else data <= {E{1'b0}};
always @(*)
    case (data)
         {C, E} : cnt = data[7];
         {H, E, H} : ct = data[6];
         {C, C, E} : cnt = data[5];
         default: cnt = 0;
    endcase
assign valid_out = data[7] == 1;
assign dout = data[4];
endmodule