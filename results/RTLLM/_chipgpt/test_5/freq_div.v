reg [3:0] cnt_1,cnt_10,cnt_100;//counter to generate output with frequency of CLK_in/2, CLK_in/10 and CLK_in/100

  always@(posedge CLK_in or posedge RST) begin
    if(RST) begin
      cnt_1<=0;
      cnt_10<=0;
      cnt_100<=0;
    end
    else begin
      cnt_1<=cnt_1+1;
      cnt_10<=cnt_10+1;
      cnt_100<=cnt_100+1;
      
      if(cnt_1==4) begin
        CLK_50<=~CLK_50;  //if count reaches 4, it will flip over.
      end
      else begin
        CLK_50<=cnt_1;
      end
      
      if(cnt_10==4) begin
        CLK_10<=~CLK_10;
      end
      else begin
        CLK_10<=cnt_10;
      end
      
      if(cnt_100==49) begin
        CLK_1<=~CLK_1;
      end
      else begin
        CLK_1<=cnt_100;
      end
    end
  end
endmodule