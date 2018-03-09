`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    VGA_640x480
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
module VGA_640x480(
	input wire clk,//50MHz
	input wire RESET,
	output HS,
	output VS,
	output [9:0]pixel,
	output [9:0]line,
	output wire video
    );

reg dclk;//分频为25mhz
reg [9:0]h_count;
reg [9:0]v_count;
always@(posedge clk or posedge RESET)begin
	if(RESET == 1)
		dclk <= 1'b1;
	else 
		dclk <= ~dclk;
end

//行计数：VGA horizontal counter(0-639+8+8+96+40+8 = 799)
always@(posedge dclk or posedge RESET)
	begin
		if(RESET == 1)
			h_count <= 10'h0;
		else if(h_count == 10'd799)
			h_count <= 10'h0;
		else
			h_count <= h_count + 10'h1;
	end

assign pixel = h_count - 10'd143;
assign HS = (h_count >= 10'd96);

//帧计数：v_count:VGA vertical counter (0-524)
always@(posedge dclk or posedge RESET)
	begin
		if(RESET == 1)
			v_count <= 10'h0;
		else if(h_count == 10'd799)
				if(v_count == 10'd524)
					v_count <= 10'h0;
				else
					v_count <= v_count + 10'h1;
end

assign line = v_count - 10'd35;
assign VS = (v_count >= 10'd2);
assign video = (((h_count >= 10'd143)&&(h_count < 10'd783)) && ((v_count >= 10'd35) && (v_count < 10'd515)));	

endmodule
