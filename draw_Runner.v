`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    20:54:53 01/05/2017 
// Design Name:    Runner
// Module Name:    draw_Runner
// Project Name:   Final Project
// Target Devices: Kintex7 - xc7k160t-2Lffg676
// Tool versions:  ISE14.7
// Description:    
//                 Developed By Atrix Lin
//��ģ��Ϊ����ʵ�ֵ���Ҫģ�飬�����У�
//1. Runner�ͱ���ͼƬ��ʱ����ʾ
//2.С��������Ծ�Ϳ����ٶȵļ���
//3.С�����ƶ�ʱͼƬ�Ľ���任
//4.����ͼƬ���ϰ�����ƶ�
//5.С�������ϰ������ײ����ж���Ϸ�Ƿ����
//6.��Ϸ����ͣ�����ù���
//7.����ʱ������ӣ��ϰ����ƶ��ٶȼӿ�
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module draw_Runner(
	input clk,//50MHzʱ��
	input [9:0]h_count,//��ʾ�ĺ�����
	input [9:0]v_count,//��ʾ��������
	input video,
	input [4:0]jump,//��Ծ����Code
	input clr,//vga����
	input [4:0]reset,//���ð���Code
	input pause,//��ͣ����
	input clk_1ms,//��Ƶ���õ�ʱ���ź�
	input clk_5ms,
	input clk_01ms,
	input clk_100ms,
	input clk_10ms,
	output reg[3:0] r,
	output reg[3:0] g,
	output reg[3:0] b,
	output gameover//�������
    );

reg [10:0]x,y;
reg gameover1;
assign gameover = gameover1;
parameter x1 = 120,x2 = 180;//Runner�ĺ�����
parameter y1 = 270,y2 = 330;//Runner�ĳ�ʼ������
parameter V0 = 82,delta = 1;//Runner�ĳ�ʼ�ٶ����ڿ��еļ��ٶ�
parameter X_over = 120;
parameter Y_over = 130;//����ͼƬ�ĺ�������
parameter Y_ground1 = 267,Y_ground2 = 310,Y_tree1 = 250,Y_tree2 = 268;//�������ϰ����������
integer V,count,diff,count1;			
integer ground,tree1,X_tree1,X_tree2,X_cloud1,X_cloud2,X_cloud3,Y_cloud1,Y_cloud2,Y_cloud3;

reg [10:0] Y, S,high_ground1,high_ground2,x_t1,y_t1,x_c1,x_c2,x_c3,y_c1,y_c2,y_c3,x_t2,y_t2,x_v,y_v;
reg [11:0] addr;
reg high,mode,draw_Runner1,draw_Runner2,in_ground1,in_ground2,in_tree1,in_tree2,in_cloud,in_cloud2,in_over;
wire [0:0] color1,color2,color_ground1,color_ground2,color_tree1,color_tree2,color_cloud,color_cloud2,color_over;
wire [15:0] show_ground1,show_ground2;
reg [14:0]show_over;
reg [15:0] show_tree1,show_tree2;
reg[12:0] show_cloud,show_cloud2;
reg clk_game;

initial begin
Y = y1;//YΪRunner���ڵ�λ��
V = 0;
mode = 0;
count = 0;
draw_Runner1 = 0;
ground = 0;
X_tree1 = 1200;
X_tree2 = 900;
gameover1 = 0;
Y_cloud1 = 50;X_cloud2 = 500;
Y_cloud1 = 110;X_cloud2 = 100;
diff = 60;
count = 0;
count1 = 0;
end


Demon1    Rom1(.clka(clk),.addra(addr),.douta(color1));//RunnerͼƬ1
Demon2    Rom2(.clka(clk),.addra(addr),.douta(color2));//RunnerͼƬ2 ������ʾ
ground 	 Rom3(.clka(clk),.addra(show_ground1),.douta(color_ground1));//�������?
trees1 	 Rom4(.clka(clk),.addra(show_tree1),.douta(color_tree1));	//�ϰ�1��ʾ
trees2 	 Rom5(.clka(clk),.addra(show_tree2),.douta(color_tree2));	//�ϰ�2��ʾ
clouds 	 Rom6(.clka(clk),.addra(show_cloud),.douta(color_cloud));	//��Ӱ�Ʋʵ���?
game_over Rom7(.clka(clk),.addra(show_over),.douta(color_over));	//��Ϸ����ͼƬ��ʾ

always@(posedge clk_100ms)//С��������̬ÿ100ms�ı�һ�Σ�mode == 1��ʾͼƬ1;mode == 0��ʾͼƬ2
	begin
		if(pause == 1 || gameover1 == 1) //�ж���Ϸ�Ƿ��������?			
			mode = mode;
		else mode = ~mode;
	end

always@(posedge clk_01ms)//clk_game������Ƶ����diff���ƣ�cllk_game���Ʊ������ƶ��ٶ�
	begin
		count = count + 1;
		if(count >= diff)
		begin
			count  = 0;
			clk_game = 1;
		end
		else
		clk_game = 0;
	end

always@(posedge clk_100ms)
	begin//diff����Ϸʱ������Ӷ����٣��Ӷ�ʹclk_gameƵ��Խ��Խ��
		count1 = count1 + 1;			  //ͨ����diff��difficult���ĸı����ı䱳�����ƶ��ٶȣ�����������Ϸ��?	
		if(reset == 17)
			diff = 60;
		else if(count1 >= 50)
			begin
				count1 = 0;
				if(diff > 20)
					diff = diff - 4;
				else diff = diff;
			end
	end

always@(posedge clk_game)
	begin//�������Ʊ����ƶ���ʱ�ӣ�clk_game�����Ʊ������ƶ��ٶ�
		if(clr == 1)
			begin					//��������
				ground = 0;
				X_tree1 = 1200;
				X_tree2 = 900;
			end
		else 
			begin
				if(pause == 1 || gameover1 == 1)//�ж���Ϸ�Ƿ��������?					
					ground = ground;
				else if(reset == 17)
					ground = 64;
				else if(ground <= 576)						//groundΪ���Ʊ�����ʾ��ָ�룬groundΪ������ʾ�Ŀ�ʼλ?					
					ground = ground + 1;
				else 
					ground = 64;
				if(reset == 17)
					X_tree1 = 1200;
				else if(pause == 1 || gameover1 == 1)		//�ж���Ϸ�Ƿ��������?					
					X_tree1 = X_tree1;
				else if(X_tree1 > 0 )
					X_tree1 = X_tree1 -1;								//���������ϰ����ѭ����?				
				else 
					X_tree1 = 1200;
				
				if(reset == 17)											//��λ����
					X_tree2 = 900;
				else if(pause == 1 || gameover1 == 1)		//�ж���Ϸ�Ƿ��������?					
					X_tree2 = X_tree2;
				else if(X_tree2 > 0 )
					X_tree2 = X_tree2 -1;
				else 
					X_tree2 = 900;
			
				if(reset == 17)
					begin										//��λ����
						X_cloud1 = 800;
						X_cloud2 = 700;
					end
				else if(pause == 1 || gameover1 == 1)
					begin				//�ж���Ϸ�Ƿ��������ͣ						
						X_cloud1 = X_cloud1;
						X_cloud2 = X_cloud2;
					end 
				else 
					begin
						if(X_cloud1 > 0 )
							X_cloud1 = X_cloud1 -1;							//�Ʋʵ�ѭ���ƶ�				
						else X_cloud1 = 800;
						if(X_cloud2 > 0)
							X_cloud2 = X_cloud2 - 1;
						else X_cloud2 = 700;

					end
			end
	end

assign show_ground1 = (high_ground1*640 + (ground+h_count)%512);			//��ʾ�����ƶ���ָ�룬ROM�����
assign show_ground2 = (high_ground2*640 + (ground+h_count)%512);


always@(*)
	begin 
		if(h_count >= x1 && h_count < x2 && v_count >= Y && v_count < Y+60)
			begin//�ж��Ƿ�����ʾ������λ��			
				y = v_count - Y;
				x = h_count - x1;
				addr = y * 60 + x;
				if(mode == 1 || high == 1)
					begin//ͨ��mode����draw_Runner1��draw_Runner2���������ƽ������ʾ						
						draw_Runner1 = 1;
						draw_Runner2 = 0;
					end 
				else
					begin
						draw_Runner2 = 1;
						draw_Runner1 = 0;
					end
			end
		else 
			begin
				draw_Runner1 = 0;						//������ʾ����
				draw_Runner2 = 0;
			end

		if(v_count >= Y_ground1 && v_count < Y_ground1+60 && h_count >= 1 && h_count <= 640)
			begin//�ж��Ƿ�����ʾ����	
				in_ground1 = 1;
				high_ground1 = v_count - Y_ground1;						
			end
		else 
			in_ground1 = 0;


//�ж��Ƿ���tree1
		if(v_count >= Y_tree1 && v_count <Y_tree1+100 && h_count >= X_tree1 && h_count <= X_tree1+70 && h_count >= 1 && h_count <= 640)
			begin
				in_tree1= 1;
				x_t1 = h_count - X_tree1;
				y_t1 = v_count - Y_tree1;
				show_tree1   = (y_t1 * 70 + x_t1);		//ROM�������
			end
		else 
			in_tree1 = 0;

//�ж��Ƿ���tree2
		if(v_count >= Y_tree2 && v_count <Y_tree2+60 && h_count >= X_tree2 && h_count <= X_tree2+70 && h_count >= 1 && h_count <= 640)
			begin
				in_tree2= 1;
				x_t2 = h_count - X_tree2;
				y_t2 = v_count - Y_tree2;
				show_tree2  = (y_t2 * 70 + x_t2);		//ROM�������
			end
		else
			in_tree2 = 0;

//�ж��Ƿ�����ʾcloud	
		if(v_count >= Y_cloud1 && v_count < Y_cloud1 +70 && h_count >= X_cloud1 && h_count < X_cloud1+100 && h_count >= 1 && h_count <= 640)
			begin
				in_cloud = 1;
				x_c1 = h_count - X_cloud1;
				y_c1 = v_count - Y_cloud1;
				show_cloud = (y_c1 * 100 + x_c1);		//ROM�������
			end 
		else
		if(v_count >= Y_cloud2 && v_count < Y_cloud2 +70 && h_count >= X_cloud2 && h_count < X_cloud2+100 && h_count >= 1 && h_count <= 640)
			begin
				in_cloud = 1;
				x_c2 = h_count - X_cloud2;
				y_c2 = v_count - Y_cloud2;
				show_cloud = (y_c2 * 100 + x_c2);		//ROM�������
			end
		else 
			in_cloud = 0;

//�ж��Ƿ�����ʾgameover	
		if(v_count >= Y_over && v_count < Y_over+70 && h_count >= X_over && h_count < X_over+400)
			begin
				in_over = 1;
				x_v = h_count - X_over;
				y_v = v_count - Y_over;
				show_over = y_v * 400 + x_v;				//ROM�������
			end
		else in_over = 0;
		
//vga��ʾ�ĳ�ʼ��
		r = 0;b = 0;g = 0;
		
		if(video == 1)
			begin
				r = 4'hf;
				g = 4'hf;
				b = 4'hf;
			end
		if(in_tree1 == 1)
			begin							//�������ʾ�������rgb��0		
				if(color_tree1[0] == 0)
					begin				//ROM���
						r = 0;
						g = 0;
						b = 0;
					end 
			end 
		else if(in_tree2 == 1)
			begin
				if(color_tree2[0] == 0)
					begin
						r = 0;
						g = 0;
						b = 0;
					end
			end

		if(draw_Runner1 == 1 )
			begin							//�������ʾ�������rgb��0			
				if(color1[0] == 0)
					begin						//ROM���
						r = 0;
						g = 0;
						b = 0;
					end
			end 
		else if(draw_Runner2 == 1 )
				if(color2[0] == 0)
					begin
						r = 0;
						g = 0;
						b =0;
					end

		if(in_ground1 == 1)						//�������ʾ�������rgb��0		
			if(color_ground1[0] == 0)
				begin				//ROM���
					r = 0;
					g = 0;
					b = 0;
				end		
		else if(in_ground2 == 1)
			if(color_ground2[0] == 0)
				begin
					r = 0;
					g = 0;
					b = 0;
				end

		if(in_cloud == 1)							//�������ʾ�������rgb��0
			if(color_cloud[0] ==0)
				begin				//ROM���
					r = 0;
					g = 0;
					b = 0;
				end


	//���С������ײ��ģ�飬ѡȡС������5������������ж�
		if((x1+53 >= X_tree1 + 20) &&( x1 + 53 <= X_tree1 +53) &&( Y + 17 >= Y_tree1 + 14))
			gameover1 = 1;
		else if((Y +57 >= Y_tree1 + 14) && (x1 + 35 <= X_tree1 +53 )&& (x1 +35 >= X_tree1 + 20))
			gameover1 = 1;
		else if	((Y + 57>= Y_tree1 + 14) && (x1 + 19 <= X_tree1 +53 )&&( x1+ 19 >= X_tree1 + 20))
			gameover1 = 1;
		else if ((Y + 36>= Y_tree1 + 14) && (x1 + 8  <= X_tree1 +53 )&& (x1 +8  >= X_tree1 + 20))
			gameover1 = 1;
		else if(  (Y + 37 >= Y_tree1 + 14) && (x1 + 21 <= X_tree1 + 53) && (x1 + 21 >= X_tree1 + 20))
			gameover1 = 1;
		else if( (Y + 17 >= Y_tree2 + 7 ) && (x1 + 53 >= X_tree2 + 11) && (x1 + 53 <= X_tree2 + 57))
			gameover1 = 1;
		else if( (Y+57 >= Y_tree2 + 7) && (x1 + 35 >= X_tree2 + 11 ) && (x1 + 35 <= X_tree2 + 57))
			gameover1 = 1;
		else if( (Y+57 >= Y_tree2 + 7) && (x1 + 19 >= X_tree2 + 11 ) && (x1 + 19 <= X_tree2 + 57))
			gameover1 = 1;
		else if( (Y+36 >= Y_tree2 + 7) && (x1 + 8 >= X_tree2  + 11)  && (x1 + 8 <= X_tree2 + 57))
			gameover1 = 1;
		else if( (Y+37 >= Y_tree2 + 7) && (x1 + 21 >= X_tree2 + 11) && (x1 + 21 <= X_tree2 + 57))
			gameover1 = 1;
		else gameover1 = 0;
//�����Ϸ����������ʾ"game over"
		if(gameover1 == 1)
			if(in_over == 1)
				begin
					r[0] = color_over[0];r[1] = color_over[0];r[2] = color_over[0];r[3] = color_over[0];
					b[0] = color_over[0];b[1] = color_over[0];b[2] = color_over[0];b[3] = color_over[0];
					g[0] = color_over[0];g[1] = color_over[0];g[2] = color_over[0];g[3] = color_over[0];
				end

//��Ļ����Ϳ�ɺ�
		if(((h_count >= 0 && h_count <= 64 )||(h_count >= 576 && h_count <= 640))&& v_count >= 0 && v_count <= 480 )
			begin
				r = 0;
				g = 0;
				b = 0;
			end
	end


//С����������ڿ��е�ʱ�����
always@(posedge clk_5ms)
	begin
		if(clr == 1)
			begin			
				V = 0;
				Y = y1;
			end
		else
			begin
				if(jump == 16)
					if(Y == y1)
						begin
							V = V0;
							high = 1;
						end
					else if(Y == y1 && V == 0)
						high = 0;
				if(high == 1)
					begin
						if(reset == 17)
							begin
								V = 0;
								Y = y1;
							end
						else if(pause == 1 || gameover1 == 1)
							begin						
								S = S;
								Y = Y;
								V = V;
							end 
						else if(V > -V0)
							begin
								S = (V0*V0 - V*V)/32;//���ù�ʽ���С������λ�ú��ٶ�				
								Y = y1 - S;
								V = V - delta;
							end
						else 
							begin
								V = 0;
								Y = y1;
							end
					end
			end
	end
endmodule
