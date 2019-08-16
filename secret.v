module secret(clk,reset,row,col,dig_display,dig_catch,r_col,g_col,row_dian,btn0,btn1,btn2,btn3,btn4,led);
    
    input clk,reset;
    
    input [3:0]row;

    input btn0; //从开锁状态变到闭锁状态

    input btn1; //输入之后的确定键

    input btn2; //重置密码之后的确定键

    input btn3; //开锁状态变到改密码状态

    input btn4; //密码归零按键
	 
	output [3:0]col; //键盘模块的列信号
    
    output [7:0] dig_display;   //控制数码管的显示

    output [7:0] dig_catch; //数码管选位信号

    output [7:0] r_col; //控制点阵显示的红色列信号

    output [7:0] g_col; //控制点阵显示的绿色列信号

    output [7:0] row_dian; //控制点阵显示的行信号

    output [7:0]led;
    
    wire [3:0] key_value;  //digital模块接收keyboard模块按键输入的值

    wire clk_500khz;  //500KHZ时钟信号

    wire key_flag;   //接收按键按下的信号

    wire [23:0]code; //接收digital模块输入的密码

    reg [23:0]re_code=24'b000000000000000000000000;  //当前密码锁的密码

    reg open=1'b0;//密码锁是否开启
	 


    wire lo_btn0,lo_btn1,lo_btn2,lo_btn3,lo_btn4,lo_reset;  //消抖后的按键信号

    
alarm u1(                               //例化报警模块
         .clk(clk),
         .rst(lo_reset),
         .btn0(lo_btn0),
         .btn1(lo_btn1),
         .open(open),
         .led0(led[0]),
         .led1(led[1]),
         .led2(led[2]),
         .led3(led[3]),
         .led4(led[4]),
         .led5(led[5]),
         .led6(led[6]),
         .led7(led[7]),
        );
                            
divider u2(                             //例化时钟分频模块
        .clk(clk),
        .reset(lo_reset),
        .clk_500khz(clk_500khz)
        );

digital u3(                             //例化数码管模块
        .clk(clk),
        .reset(lo_reset),
        .row(row),
        .col(col),
        .btn0(lo_btn0),
        .btn3(lo_btn3),
        .dig_display(dig_display),
        .dig_catch(dig_catch),
        .code(code),
		.count_code(count_code),
        .key_value(key_value),
        .open(open)
        );
        
display u4(                           //例化点阵显示模块
        .clk(clk),
        .rst(lo_reset),
        .open(open),
        .r_col(r_col),
        .g_col(g_col),
        .row_dian(row_dian)
        );
        
        initial begin
          open=1'b0;
        end
debounce u5(                      //例化消抖模块
        .clk(clk),
        .key(btn0),
        .lo_key(lo_btn0)
         );

debounce u6(
        .clk(clk),
        .key(btn1),
        .lo_key(lo_btn1)
         );

debounce u7(
        .clk(clk),
        .key(btn2),
        .lo_key(lo_btn2)
         );

debounce u8(
        .clk(clk),
        .key(btn3),
        .lo_key(lo_btn3)
         );

debounce u9(
        .clk(clk),
        .key(btn4),
        .lo_key(lo_btn4)
         );

debounce u10(
        .clk(clk),
        .key(reset),
        .lo_key(lo_reset)
         );
    
    always @ ( posedge lo_btn0 or posedge lo_btn1 or posedge lo_btn2 or posedge lo_btn3 or posedge lo_btn4 or posedge lo_reset)
        begin
            if(lo_reset)
            begin
              open<=1'b0;  //复位后密码锁回到闭锁状态
            
            end
            else if(lo_btn0)  //按下btn0，密码锁回到闭锁状态
            begin
              open<=1'b0;
            
            end

            else if(lo_btn1)   //按下btn1，检测lo_btn1，若为1，检查digital模块传出的密码是否正确
            begin
              if(code==re_code)
                open<=1'b1;
              else
                begin
                    open<=1'b0;
                  
                end
                
            end
        end
		  
		  
        // 按下btn3之后数码管会显示横线，表明进入了重置密码状态
		  
		  
        always @(posedge lo_btn2 or posedge lo_btn4 )   //在这个模块了实现重置密码和密码清零（不要问我为什么换一个always块，我为此耗了一整天）
        begin
            if(lo_btn2) //按下btn2，在开锁状态把新输入的密码设为当前密码
            begin
               if(open)
                 re_code<=code;
            end
				
		    else if(lo_btn4)//按下btn4，在开锁状态下把密码重设为0
		    begin
            if(open)
                 re_code<=24'b000000000000000000000000;
            end
				
           
        end
		  
        

endmodule   