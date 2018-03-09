`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    clk_01ms
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
module clk_01ms(
	input clk,
	input reset,
	output clk_01ms
	);
reg[20:0] count;
reg second_m;
assign clk_01ms = second_m;

initial count <= 0;

always@(posedge clk)
	begin
		if(reset || (count == 4999))
		begin
			count <= 0;
			second_m <= 1;
		end
	    else begin
			count <= count + 1;
			second_m <= 0;
		end
	end

endmodule
