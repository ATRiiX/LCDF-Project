`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    counter_clk
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
module counter_clk(clk, clk_1s);   
input wire clk;
output reg clk_1s=0;
reg [31:0] cnt;

always @ (posedge clk) 
    begin
        if (cnt < 50000000) 
            cnt <= cnt + 1;
        else begin
            cnt <= 0;
            clk_1s <= ~clk_1s;
        end
    end
    
endmodule


