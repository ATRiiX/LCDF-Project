`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    TOP
// Project Name:   Final Project
// Target Devices: Kintex7 - xc7k160t-2Lffg676
// Tool versions:  ISE14.7
// Description:    
//                 Developed By Atrix Lin
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module TOP(
	input wire clk,//100MHz时钟
	input wire rstn,
	input wire[15:0]SW,//Switch					

	output wire HS,//VGA
	output wire VS,
	output [3:0] r,
	output [3:0] g,
	output [3:0] b,

	output SEGLED_CLK,//SEG接口
	output SEGLED_CLR,
	output SEGLED_DO,
	output SEGLED_PEN,
	
	output wire Rc,//四位七段数码管
	output wire [3:0] AN,
	output wire [7:0] SEGMENT,
	
	inout [4:0]BTN_X,//keypad
	inout [3:0]BTN_Y,

	output buzzer
    );

wire pause,clr;
wire clk_1ms,clk_10ms,clk_5ms,clk_150ms,clk_100ms,clk_20ms,clk_01ms;//分频的时钟
clk_1ms     U3(.clk(clkdiv[0]),.reset(clr),.clk_1ms(clk_1ms));
clk_5ms     U4(.clk_1ms(clk_1ms),.reset(clr),.clk_5ms(clk_5ms));
clk_100ms   U5(.clk_1ms(clk_1ms),.reset(clr),.clk_100ms(clk_100ms));
clk_10ms   U6(.clk_1ms(clk_1ms),.reset(clr),.clk_10ms(clk_10ms));
clk_01ms   U7(.clk(clkdiv[0]),.reset(clr),.clk_01ms(clk_01ms));

wire [4:0] jump,reset;
wire [15:0] SW_OK;
wire gameover;
assign clr = SW_OK[0];	 
assign reset = keyCode;
assign pause = SW_OK[1];
assign jump = keyCode;
assign buzzer = 1'b1;


reg [31:0]clkdiv;
always@(posedge clk)
	begin
		clkdiv <= clkdiv + 1'b1;
	end

	
AntiJitter #(4) a0[15:0](.clk(clkdiv[15]), .I(SW), .O(SW_OK));   //按键去抖动->SW_OK	
wire [4:0] keyCode;
wire keyReady;
Keypad k0 (.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .ready(keyReady));   //Keypad->KeyCode


wire video;
wire[9:0]h_count;
wire[9:0]v_count;
VGA_640x480 U1(.clk(clkdiv[0]),.RESET(clr),.HS(HS),.VS(VS),.pixel(h_count),.line(v_count),.video(video));//VGA模块

draw_Runner U2(.clk(clkdiv[0]),.video(video),.h_count(h_count),.v_count(v_count),.r(r),.g(g),.b(b),
				.jump(jump),.clk_5ms(clk_5ms),.clk_100ms(clk_100ms),.clk_10ms(clk_10ms),.pause(pause),.clr(clr),.reset(reset),
				.clk_1ms(clk_1ms),.clk_01ms(clk_01ms),.gameover(gameover));
//主要游戏逻辑模块


wire clk_1s;
wire [15:0] cntt;
counter_clk c0(clk,clk_1s);	//计分板时钟	
counter_16bit_rev c2(.clk(clk),.clk_1s(clk_1s),.s(pause),.reset(reset),.cnt(cntt),.gameover(gameover),.Rc(Rc));//计分开始、暂停、重置
dispnum1 c1(clk,cntt,4'b0000,4'b0000,1'b0,AN,SEGMENT);//计分显示与数码管


assign SEGLED_CLR = sout[0];//八位数码管（未使用）
assign SEGLED_PEN = sout[1];
assign SEGLED_DO = sout[2];
assign SEGLED_CLK = sout[3];	
reg [31:0] score=0;                                                    	
wire [31:0] segTestData;
assign segTestData = score;
wire [3:0]sout;
Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
					.data(segTestData), .point(8'h0), .LES(8'h0),.sout(sout));

endmodule
