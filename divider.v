module divider(clk,clk_500khz,reset) ;
    input clk;

    input reset;

    output clk_500khz;

    reg clk_500khz;  //500KHZ时钟信号

    reg [5:0] count;//delay_20ms


always @(posedge clk or posedge reset)  //创建一个50kHz的时钟用于数码管扫描显示

            begin
                if(reset)
                  count<=0;

            else if(count>=50) begin clk_500khz<=~clk_500khz;count<=0;end

            else count<=count+1;

        end

endmodule 

