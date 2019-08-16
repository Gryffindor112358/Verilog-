module digital(clk,reset,row,btn0,btn3,dig_display,dig_catch,code,count_code,col,key_value,open);
    
    input clk,reset;
    
    input [3:0]row;

    input btn0;

    input btn3;

    input open;

    output [3:0]col;
    
    output reg[7:0] dig_display;   //控制数码管的显示
    
    output reg[7:0] dig_catch=8'b11111111; //数码管选位信号

    output reg[23:0]code=24'b101010101010101010101010; //输入的密码将传送至顶层模块(现在是最初要显示的状态)

    reg [23:0]entermark=24'b101110111011101110111011;  //在闭锁状态下数码管显示的内容
    
    output [4:0] key_value;   //键盘按下的值

    wire clk_500khz;  //500KHZ时钟信号

    reg [3:0]count_catch=4'd0;  //控制数码管选位的计数器

    output reg [3:0]count_code=4'd0; //控制密码选位的计数器

    reg [3:0]digit;  //数码管显示的内容

    wire key_flag;   //接收按键按下的信号

  
  
keyboard u1(                        //例化键盘扫描模块

    .clk(clk),  //50MHZ

    .reset(reset),

    .row(row),   //行

    .col(col),

    .keyvalue(key_value),  //键值

    .keyflag(key_flag)

 );

divider u2(
        .clk(clk),
        .reset(reset),
        .clk_500khz(clk_500khz)
        );
  
  always @(posedge reset or posedge btn3 or posedge btn0 or negedge key_flag)  //按键状态每改变一次，计数器相应加一,然后在对应位置改变code值
      begin
        if(reset)  //按下reset键计数器归零，数码管显示entermark初始状态（数码管全不亮
          begin
            count_code<=4'd0;
            entermark<=24'b101110111011101110111011;
          end

        else if(btn3)  //按下btn3进入修改密码状态，数码管显示横线
        begin
            count_code<=4'd0;
            code<=24'b101010101010101010101010;
        end
        else if(btn0)   //按下btn0键进入闭锁状态，数码管什么都不显示
        begin
            count_code<=4'd0;
            entermark<=24'b101110111011101110111011;
        end
      
        
        else if(count_code==4'd6)  
          count_code<=4'd0;
        else if(count_code<4'd6)
        begin
          case(count_code)   //根据count_code的值在code和entermark的相应位置做修改
            0:begin code[23:20]=key_value;entermark[23:20]=4'b1010;end
            1:begin code[19:16]=key_value;entermark[19:16]=4'b1010;end
            2:begin code[15:12]=key_value;entermark[15:12]=4'b1010;end
            3:begin code[11:8]=key_value;entermark[11:8]=4'b1010;end
            4:begin code[7:4]=key_value;entermark[7:4]=4'b1010;end
            5:begin code[3:0]=key_value;entermark[3:0]=4'b1010;end
            default: ;
          endcase
          count_code=count_code+4'd1;
      end
      end
		
 
    
    always @(posedge clk_500khz or posedge reset)  
      begin
        if(reset)
          begin
            count_catch<=4'd0;
          end
        else if(count_catch==4'd6)
          count_catch<=4'd0;
        else if(count_catch<4'd6)
        begin
          if(open)   //在开锁状态下，修改密码时数码管依次显示键入的值
          begin
          case(count_catch)

            0:
              begin
                dig_catch<=8'b11111110;     //扫描的同时赋值为相应要显示的内容
                digit<=code[3:0];
              end
            1:
              begin
                dig_catch<=8'b11111101;
                digit<=code[7:4];
              end
            2:
              begin
                dig_catch<=8'b11111011;
                digit<=code[11:8];
              end
            3:
              begin
                dig_catch<=8'b11110111;
                digit<=code[15:12];
              end
            4:
              begin
                dig_catch<=8'b11101111;
                digit<=code[19:16];
              end
            5:
              begin
                dig_catch<=8'b11011111;
                digit<=code[23:20];
              end
            endcase
          count_catch=count_catch+4'd1;
          end

          else if(!open)   //在闭锁状态下，输入密码时，数码管依次显示横线
          begin
            case(count_catch)

            0:
              begin
                dig_catch<=8'b11111110;     //扫描的同时赋值为相应要显示的内容
                digit<=entermark[3:0];
              end
            1:
              begin
                dig_catch<=8'b11111101;
                digit<=entermark[7:4];
              end
            2:
              begin
                dig_catch<=8'b11111011;
                digit<=entermark[11:8];
              end
            3:
              begin
                dig_catch<=8'b11110111;
                digit<=entermark[15:12];
              end
            4:
              begin
                dig_catch<=8'b11101111;
                digit<=entermark[19:16];
              end
            5:
              begin
                dig_catch<=8'b11011111;
                digit<=entermark[23:20];
              end
            endcase
          count_catch=count_catch+4'd1;
          end
          end
      end


    always @(posedge clk)  
    begin
        case(digit)   //控制数码管的显示
          4'd0:  dig_display<=8'b11111100;   //显示0
          4'd1:  dig_display<=8'b01100000;
          4'd2:  dig_display<=8'b11011010;
          4'd3:  dig_display<=8'b11110010;
          4'd4:  dig_display<=8'b01100110;
          4'd5:  dig_display<=8'b10110110;
          4'd6:  dig_display<=8'b10111110;
          4'd7:  dig_display<=8'b11100000;
          4'd8:  dig_display<=8'b11111110;
          4'd9:  dig_display<=8'b11110110;  //显示9
          4'd10: dig_display<=8'b00000010;  //显示横线
          4'd11: dig_display<=8'b00000000;  //什么都不显示
          endcase
    end
    


endmodule  