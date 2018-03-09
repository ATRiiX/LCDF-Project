`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    counter_16bit_rev
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
module counter_16bit_rev(clk,clk_1s,s,reset,gameover,cnt,Rc);
input wire clk,clk_1s,s;
input [4:0]reset;
input gameover;
output reg [15:0] cnt;
output wire Rc;

initial begin 
cnt = 0;
end

assign Rc=(~s&(~|cnt))|(s&(&cnt));

always @(posedge clk_1s) 
	begin
		if (reset==17 ) cnt<=0;	
		if(~s & reset!=17 & gameover ==0 )
		begin
			cnt<=cnt+1;
			if(cnt[3:0]==9) cnt<=cnt+7;
			if(cnt[7:0]==89) cnt<=cnt+167;
			if(cnt[11:0]==2393) cnt<=cnt+1703;
			if(cnt[15:0]==9049) cnt<=0;
		end
	end

endmodule
