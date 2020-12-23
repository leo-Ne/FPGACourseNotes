//counter++

// 同步加载计数器
module FDIV0(
	input CLK, RST,
	input [3:0] D,
	output PM,
	output [3:0] DOUT
);
	reg[3:0] Q1;
	reg FULL;
	(* synthesis, keep *) wire LD; /* 设定LD仿真可测试属性 */
	always@(posedge CLK or negedge RST)
		if(!RST) begin Q1<=0; FULL<=0;end
		else if(LD) begin Q1<=D; FULL<=1;end
		else 		begin Q1<=Q1+1;FULL<=0;end
	assign LD=(Q1==4'B1111); 
	assign PM=FULL;
	assign DOUT=Q1;
endmodule

// 异步加载计数器
module FDIV0(
	input CLK, RST,
	input [3:0] D,
	output PM,
	output [3:0] DOUT
);
	reg[3:0] Q1;
	reg FULL;
	(* synthesis, probe_port, keep *) wire LD;
	always@(posedge CLK or negedge RST)
		if(!RST) begin Q1<=0; FULL<=0;end
		else if(LD) begin Q1<=D; FULL<=1;end
		else 		begin Q1<=Q1+1;FULL<=0;end
	assign LD=(Q1==4'b0000); 
	assign PM=FULL;
	assign DOUT=Q1;
endmodule
/* 比较一下，前两种计数器的同步和异步设计*/

// 异步加载清0计数器
module fdiv1(CLK, PM, D);
	input CLK;
	input[3:0] D; 
	output PM;
	reg FULL;
	(* synthesis, probe_port, keep *) reg[3:0] Q1;
	(* synthesis, probe_port, keep *) wire[3:0] RST;
	always@(posedge CLK or posedge RST)
		if(RST) begin Q1<=0; FULL<=1;end
		else begin Q1<=Q1+1; FULL<=0;end
	assign RST<=(Q1==D);
	assign PM<=FULL;
endmodule

// 1位十进制加/减计数器
/* TRUTH TABLE
CLOCK UP	 	COLOCK DOWN 		RESET 		PARALLEL LOAD 	FUNCTION
up			H				L 			H				Count up
H 			up 				L     		H				Count Down
X      		X  				H             X                 Reset
X 			X 				L 			L  				Load Preset Inputs	
*/
module dec_calc(
	input mr,		//异步清零信号，高电平有效
	input pl_n,		//异步置数信号，低电平有效
	input cpu,		//加法计数时钟
	input cpd,		//减法计数是时钟
	input [3:0] p, 	//4位预置数输入端
	input [3:0] q, 	//计数结果
	output tcu,		//加法计算时的进位输出信号，低电平有效
	output tcd		//减法器计数时的借位信号，低电平有效。
);
	reg[3:0] q1, q2;
	reg 	 sel1, sel2;
	// 初始化 进位/借位 状态
	assign   tcu=(q1==9) ? 1'b0:1'b1;
	assign   tcu=(q2==0) ? 1'b0:1'b1;
	
	//加法计数过程
	always@(posedge cpu or posedge mr or negedge pl_n) begin
		if(mr==1'b1) begin
			q1<=0;
			sel1<=1'b0;end
		else if(pl_n==1'b0) begin
			q<=p;			end
		else begin
			if(cpd==1'b1) begin
				sel1<=1'b1;
				if(q1==4'd9) begin
					q1<=0;   end
				else begin
					q1<=q1+1'b1; end
			end
		end
	end
	//减法过程
	always@(posedge cpd or posedge mr or negedge pl_n)
		if(mr==1'n1) begin
			q2<=0;
			sel2<=1'b0;end
		else if(pl_n==1'b0) begin
			q2<=p; 			end
		else begin
			if(cpu==1'b1) begin 
				sel2<=1'b1;
				if(q2==0) begin
					q2<=4'd9;end
				else begin
					q2<=q2-1'b1;end
			end
		end
	end
	// 整合
	always@(*) begin
		case({sel1, sel2})
			2'b01:begin q=q1;end
			2'b10:begin q=q2;end
			default:begin q=0;end
		endcase
	end
endmodule		
// 任意范围加法计数器
/* 判断当前计数值是否等于计数最大值，如果相等，将计数值设为初始值，同时产生进位信号*/
module d20_adder
#(
	parameter d=2,
	parameter p=8
)
( 
	input clk,
	output reg[3:0] q,
	output reg co
};
	always@(posedge clk) begin
		if(q==p) begin
			q<=d;
			co<=1'b1;end
		else begin
			q<=q+1'b1;
			co<=1'b0; end
	end
endmodule

// 60进制计数器，异步复位、同步使能、同步装载、同步清零、同步置位
module cnt60x
(
	input clk,
	input reset,
	input[5:0] d,
	input en,
	input load,
	input sclr,
	output reg[5:0] q,
	output cout
);
	always@(posedge clk or posedge reset)
		if(reset)
			q<=0;
		else if(sclr)
			q<=0;
		else if(en)
			if(q<60-1)
				q<=q+1'b1;
			else
				q<=0;
	assign cout=(q==60-1)
endmodule