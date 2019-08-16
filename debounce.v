module debounce(clk,key,lo_key);
  
  input clk;

  input key;

  output reg lo_key;

  reg [19:0]tcnt;

       always @(posedge clk or negedge key)//记数按键的消抖处理
         begin
	       if(!key)tcnt<=20'd0;
	       else tcnt<=tcnt+1;
         end
      always @(posedge clk or negedge key)
         begin
	       if(!key)lo_key<=0;
	       else if(tcnt==20'hfffff)lo_key<=key;
         end

endmodule