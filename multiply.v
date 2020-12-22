//乘法器
/*
乘法器具有高速性能，它在数字信号处理和现代通信技术中有广发的应用。

乘法器类型：移位累加乘法器、流水线乘法器。


1. parameter localparam 参数定义关键词

parameter 标识符名1 = 表达式或数值1， 标识符2=表达式或数值2，...
localparam 与parameter类似。它是局部定义关键词，但是无法通过外部程序的数据传递来改变localparam定义的常量。

2. integer 标识符1， 标识符2，..., 标识符n [msb, lsb];
reg类型必须明确定义其位数。但是integer类型的定义不必特质位数，因为他们都是默认为32的二进制寄存器类型。
*/

module EXAPL (R, G);
	parameter S=4;
	output [2*S:1] R, G;
	integer A, B[3:0]; // 定义5个intege类型的：A、B[0]、B[1]、B[2]、B[3]
	reg[2*S:1] R, G;
	always@(A, B) 
		begin
			B[2] = 367;
			R = B[2];
			A = -20;
			G=A;
			B[0] =3'B101;
		end
endmodule

/*
3. for语句用法
for(循环初始值设置表达式； 循环控制条件表达式； 循环控制变量增值表达式)
	begin 循环体结构 end

4. 移位操作符
 V >> n 或 V << n     无符号数位移
 V >>> n 或 V >>> n   有符号数位移
 有符号左右移动，右移一律将符号，即最高位填补移出的位。左移操作同普通左移<<.
eg.
output signed [7:0] y;
input signed [7:0] a;
assign y = (a <<< 2);
若 a=10101011, 则输出y=10101100
若 a=10001111, 则输出y=00111100

parameter C=8'sb10101011;
parameter D=8'sb01001110;
output [7:0] Y1, Y2;
assign Y1=(C>>>2); //结果Y1=11101010
assign Y2=(D>>>2); //结果y2=00010011

5. 乘法器
*/
//
module MULT4B(R, A, B);
	parameter S=4;
	output[2*S:1] R;
	input[S:1] A, B;
	reg[2*S:1] R;
	integer i;
	always@(A or B)
	begin
		R = 0;
		for(i=1; i<=S; i=i+1)
			if(B[i]) R=R+(A<<(i-1));
			// core algorithm
	end
endmodule

module MULT4B (R, A, B);
parameter S=4;
output[2*S:1] R;
input[S:1] A, B;
reg[2*S:1] R; reg[S:1] BT, CT;
always@(A, B)
	begin
		R=0; 
		// {S{1'B0}} 位宽为S，值为0 
		AT={{S{1'B0}}, A};
		BT=B;
		CT=S;
		for(CT=S; CT>0; CT=CT-1)
			begin
				if(BT[1]) R=R+AT;
				AT=AT<<1;
				BT=BT>>1;
			end
	end
endmodule

/*
6. repeat语句用法

repeat(循环次数表达式)
	begin 循环体结构 end
循环次数表达式是可以数值确定的证书、变量、定义为常数的参数标识符
repeat语句的循环词数是在进入此语句执行以前就已经决定的，无需循环次数控制增量表达式。

7. while 语句
while (循环控制条件)
	begin 循环体语句结构 end

eg.
// 感觉下面这个是错误的乘法器
// 起始下标为 0 ？？？
*/
module MULT4B(R, A, B)
parameter S=4;
output[2*S:1] R;
input[S:1] A, B;
reg [2*S:1] TA, R;
reg[S:1] TB;
always@(A or B) begin
	R=0;
	TA=A;
	TB=B;
	repeat(S) begin
		if(TB[1]) begin R=R+TA; end
		TA=TA<<1;
		TB=TB>>1;
	end
end
endmodule

module MULT4B(R, A, B);
parameter S=4;
output[2*S:1] R;
input[S:1] A, B;
reg[2*S:1] R, AT;
reg[S:1] BT, CT;
always@(AT or B) begin
	R=0;
	AT={{S{1'b0}}, A};
	BT=B; CT=S;
	while(CT > 0) begin
		if(BT[1]) R=R+AT; else R=R;
		begin
			CT = CT-1;
			AT=AT<<1;
			BT=BT>>1;
		end
	end
end
endmodule


/*
8. parameter参数传递功能。
//
module MULT4B #(parameter S=4) (R, A, B);
或者 module MULT4B #(parameter S) (R, A, B);
eg*/

module MULTB(RP, AP, BP);
output[15:0] RP;
input[7:0] AP, BP;
MULT4B #(.S(8)) U1（.R(RP), .A(AP), .B(BP));
endmodule

//模块描述语句和参数表述
module SUB_E 
	#(parameter S1=4, parameter S2=5, parameter S3=2)(A, B, C);
endmodule

/*
例化语句
SUB_E #(.S1(8), .S2(9), .S3(7))
	U1(.C(CP), .B(BP), .A(AP));
元件U1的S1、S2、S3被定义为8、9、7。4, 5,2是默认的参数值。
*/
 
/*
9 n位乘加器
*/
module MAC_N
#(parameter N=16)
(
	input[N-1:0] A,
	input[N-1:0] B,
	input[N-1:0] C,
	input[2*N-1:0] R
);
assign R = A * B + C;
endmodule

module muln
#(
	parameter N=24
)
(
	input[N-1:0] A;
	input[N-1:0] B;
	output[2*N-1:0] RP
);
assign R=A*B;
endmodule	

/*
RTL的概念 
Register Transport Level
寄存器传输级

系统级与行为级  RTL  门级

RTL图组成的元件 
加法器、减法器、乘法器、除法器、取余模块、多路选择器、译码器。
逻辑门、寄存器、寄存器组、储存单元、存储阵列。

RTL级有Verilog描述

RTL级
可以无寄存器
状态储存单元+组合逻辑
比门级更高一级的逻辑电路描述
已经对应硬件电路的结构
Verilog描述的模块大多早RTL层次
RTL的思想可以知道Verilog代码的编写。
*/






















