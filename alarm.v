module alarm(clk,rst,btn0,btn1,open,led0,led1,led2,led3,led4,led5,led6,led7);
	
	input clk;

	input rst;

	input btn0;

	input btn1;

	input open;

	output reg led0;

	output led1,led2,led3,led4,led5,led6,led7;

	reg [25:0]count=26'd0;

	reg flag=1'd0;

	assign judge={flag,open};


	always @(posedge clk)  //实现秒级时钟的计数器，可以控制led灯闪烁
		begin
			if(count==26'd50000000)
				count<=26'd0;
			else
				count<=count+26'd1;
		end

	always @ (posedge clk or posedge btn1 or posedge btn0 or posedge rst)
	begin
		if(rst) //复位之后，led灯不亮，flag值为0
		begin led0<=0;flag<=0;end
		else if(btn0)  //按下btn0进入闭锁状态，led灯不亮，flag值为0
		begin
		led0<=0;
		flag<=0;
		end
		else if(btn1)  //按下btn1后，flag设为1，，如果输入的密码不对，那么在flag为1的时间内，led灯闪烁报警，直到回到闭锁状态或reset
		begin
		flag=1;
		end
		else if(flag)
		begin
		case(open)
		0:led0<=count[25];
		default:led0<=0;
		endcase
		end
	end

	assign led1=led0;
	assign led2=led0;
	assign led3=led0;
	assign led4=led0;
	assign led5=led0;
	assign led6=led0;
	assign led7=led0;
	assign led8=led0;


endmodule 