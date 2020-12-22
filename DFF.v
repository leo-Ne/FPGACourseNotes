//DFF
/*
DFF
1.基本的D触发器。
2.含异步复位和始终使能的D除法器。
3.含同步复位控制的D除法器。

1.基本的D触发器。
D触发器的基本概念。
略
*/
module DFF1(CLK, D, Q);
	output Q;
	input CLK, D;
	reg Q;
	always@(posedge CLK)
	Q <= D;
endmodule

// posedge CLK时钟上升沿敏感
// negedge CLK时钟下降沿敏感

// 2.含异步复位和始终使能的D除法器。

module DFF2(CLK, D, Q, RST, EN);
	output Q;
	input CLK, D, RST, EN;
	reg Q;
	always@(posedge CLK or negedge RST)
	begin
		if (!RST) Q<=0;
		else if(EN) Q<=D;
	end
endmodule

// 3.含同步复位控制的D除法器。

module DFF3（CLK, D, Q, RST);
	output Q;
	input CLK, D, RST;
	reg Q;
	always@(posedge CLK)
		if(RST==1) Q=0;
   else if(RST==0) Q=D;
endmodule


module DFF4(CLK, D, Q， RST);
	output Q;
	input CLK,D,RST;
	reg Q, Q1;
	always@(RST)    
		if(RST==1) Q1=0; else Q1=D;
	always@(posedge CLK)
		Q <= Q1;
endmodule

module DFF5
(
	input  CLK,
	input D,
	input RST,
	output reg Q
)
	always@(posedge CLK)
	Q <= RST ? 1'b0 : D;
endmodule

// RTL 异步和同步的概念

/* my code */
module DFF6
(
	input D, EN, CLK, RST,
	output reg Q1, Q
);
	always@(D, EN, RST)begin
		Q1 = ~(D&EN)|RST; 
	end
	always@(posedge CLK or negedge RST)	begin
		if(!RST)
			Q <= 0;
		else if(EN)
			Q <= D;
	end
endmodule

/* teacher's code */
module DFF6
(
input EN, CLK, D, RST,
output reg Q1,Q
);
	wire Q10;
	assign Q10 = D&EN;
	assign Q1 = (~Q10) | RST;
	
	always@(posedge CLK or negedge RST) begin
		if(!RST)
			Q <= 0;
		else if(EN)
			Q <= D;
	end
endmodule


module DFF7(
	input clk, rst_n, a, b，
	output cout,
	output reg q
)
	wire D = a&rst_n;
	assign cout = a^b;
	always@(posedge clk) begin
		q <= D;
	end
endmodule

/* teacher's code */
module DFF7_1(clk, a, b, rst_n, q, cout);
	input clk, a, b, rst_n;
	output q, cout;
	reg q;
	always@(posedge clk) begin
		if(!rst_n)
			q<=0;
		else
			q<=a;
	end
	assign cout=a^b;
endmodule	