module display(clk,rst,open,r_col,g_col,row_dian);

  input clk,rst;

  input open;  //检查密码锁是否开启，在未开启状态显示闭锁图形，开启后一直显示开锁图形

  output reg [7:0] r_col;

  output reg [7:0] g_col;

  output reg [7:0] row_dian;

  reg [3:0] row_num=4'b0000; //点阵行数控制器

  reg [7:0] row_temp=4'b0000;

  wire clk_500khz;  //500KHZ时钟信号

  divider u3(
        .clk(clk),
        .reset(rst),
        .clk_500khz(clk_500khz)
        );
  
                                         //点阵行扫描
    always @(posedge clk_500khz) begin
    if(row_num!=4'b1000) begin
        row_num<=row_num+1;
    end
    else row_num<=4'b0000;
    end

    always @(posedge clk_500khz) begin
    case(row_num)
    4'h0: begin
        row_dian<=8'b1111_1110;
    end
    4'h1: begin
        row_dian<=8'b1111_1101;
    end
    4'h2: begin
        row_dian<=8'b1111_1011;
    end
    4'h3: begin
        row_dian<=8'b1111_0111;
        
    end
    4'h4: begin
        row_dian<=8'b1110_1111;
        
    end
    4'h5: begin
        row_dian<=8'b1101_1111;
        
    end
    4'h6: begin
        row_dian<=8'b1011_1111;
        
    end
    4'h7: begin
        row_dian<=8'b0111_1111;
        
    end
    endcase
end


always @(posedge clk_500khz)
    begin
        if(!open)  //未开启，显示闭锁状态
      begin
            g_col<=8'b00000000;
        case(row_num)
            4'd0:r_col<=8'b01111110;
            4'd1:r_col<=8'b01000010;
            4'd2:r_col<=8'b01000010;
            4'd3:r_col<=8'b01111110;
            4'd4:r_col<=8'b00100100;
            4'd5:r_col<=8'b00100100;
            4'd6:r_col<=8'b00111100;
            4'd7:r_col<=8'b00000000;
        endcase
      end


        else if(open) //开启时，显示开锁图形
      begin
            r_col<=8'b00000000;
            case(row_num)
            4'd0:g_col<=8'b01111110;
            4'd1:g_col<=8'b01000010;
            4'd2:g_col<=8'b01000010;
            4'd3:g_col<=8'b01111110;
            4'd4:g_col<=8'b00000100;
            4'd5:g_col<=8'b00000100;
            4'd6:g_col<=8'b00111100;
            4'd7:g_col<=8'b00000000;
        endcase
      end
    end
    

endmodule