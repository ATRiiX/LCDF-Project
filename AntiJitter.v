`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    clk_1ms
// Project Name:   AntiJitter
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
module AntiJitter(                  
	input clk,
	input I,
	output reg O
);
parameter WIDTH = 20;
reg [WIDTH-1:0] cnt = 0;

always @ (posedge clk)
	begin
		if(I)
			if(&cnt)
				O <= 1'b1;
			else
				cnt <= cnt + 1'b1;
		else
			if(|cnt)
				cnt <= cnt - 1'b1;
			else
				O <= 1'b0;
	end

endmodule
