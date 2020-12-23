module MUX41a(
	input a, b, c, d,
	output s1, s0，
	output y);
	reg y;  // 端口为被赋值量时，需要定义为reg类型。
	always@(a or b or c or d or s1 or s0)
		begin : MuX41 // 块语句开始， 块名可省略。
			case({s1, S0})
				2'b00: y=a;
				2'b01: y=b;
				2'b10: y=c;
				2'b01: y=d;
				default: y=a;
			endcase
		end
endmodule
/*
1 reg 变量

reg 变量1， 变量2，
reg [msb: lsb] 变量1， 变量2， 。。。

(2)在过程always@引导的顺序语句中，被赋值信号规定必须是reg型变量。
(3)输入或者双向信号不能定义为reg型。
verilog-2001版本允许在端口表中对端口变量定义矢量，甚至定义端口的数据类型。这些定义可一并放在端口名表中。
eg. module seg_7(input [3:0] num, input en, output reg[6:0] seg);
*/
/*
2 过程语句
always引导语句
initial引导语句

always@(敏感信号及敏感信号列表或表达式)
	包括块语句的各类顺序语句

敏感信号发生变化时，块语句就会执行一次。类似于VHDL锁定时钟的语句。

3 块语句(只用于always引导的顺序语句)
	begin [: 块名]
		语句1；
		语句2；
		...;
		语句n；
	end
	
*/
//4 _case_条件语句
/* 
case (表达式)
	value1: begin 语句1；语句2；... ; end
	value2： begin 语句1；语句2；.. ; end
	...
	default: begin 语句1; 语句2; ...;end
endcase
*/
/*
5 verilog 的四种逻辑状态
(1) 0:含义有四个，即二进制数0、低电平、逻辑0、事件为伪的判断结果。
(2) 1:含义有四个，即二进制数1、高电平、逻辑1、事件为真的判断结果。
(3) z或Z。高组态，或高阻值。
(4) x或X。不确定，或未知的逻辑状态。x与Z的大小写都不分。
高阻值还可以用“？”表示，但“？”还有别的含义和用处，即表示“不关心”的意思。因此可以用问号“？”代替一些位值，以表示逻辑关系中对这些位不在乎是什么值。
*/

/*
6 并位操作运算符
{a1, b1, 4{a2, b2}} = {a1, b1, {a2, b2}, {a2, b2}, {a2, b2}, {a2, b2}}={a1, b1, a2, b2, a2, b2, a2, b2, a2, b2}
*/
/*
7 Verilog的数字表达形式
<位宽> '<进制> <数字>
(1) B：二进制 O:八进制 H：十六进制 D:十进制
(2)不分大小写， 如2'b10 , 4'hA等
(3) sb定义有符号的二进制数： 8'sb10111011,最高位1是符号。
*/

module MUX41a(
	input a, b, c, d, s1, s0, 
	output reg y);
	wire[1:0] SEL
	wire AT, BT, CT, DT;
	assign SEL = {s1, s0};
	assign AT = (SEL==2'D0);
	assign BT = (SEL==2'D1);
	assign CT = (SEL==2'D2);
	assign DT = (SEL==2'D3);
	assign y = (a&AT)|(b&BT)|(c&CT)|(d&DT);
endmodule

/*
1. 按位逻辑操作符
	不等长时，短的左端补0
2. 等式操作符
	==: 如果其中有X或z，就判定为假；===：将x或z都当成确定的值进行比较。
3. assign 连续赋值语句
	(1)当等号右侧的驱动表达式中的任一信号发生变化时，此表达式即被计算一次，并将获得的数据立即赋值给等号左侧的变量名标识的目标变量名。
	(2) 当一个模块中有多个assign语句时，这些语句为并行，同一目标变量名下时不允许有多个不同的赋值表达式。
		eg. 
		assign DOUT = a&b|c;
		assign DOUT = e&f|d;

4 wire 语句
	(1) wire 定义网线变量名
	(2) wire [msb, lsb] 变量名1， 变量名2....
	wire Y = tmp1 ^ tmp2;
	wire a1, a2; assign Y = a1^a2;
*/
module MUX41a(
	input A,B,C,D,S1,S0,
	output Y);
	output Y;
	wire AT = S0 ? D : C;
	wire BT = S0 ? B : A;
	wire Y = (S1 ? AT : BT);
endmodule

module MUX41a(A, B, C, D, S1, S0, Y);
	input A, B, C, D, S1, S0; output Y;
	reg[1:0] SEL; reg Y;
	always@(A, B，C，D，SEL)
		begin 
			SEL = {S1, S0}
			if(SEL == 0)     Y=A;
			else if (SEL==1) Y=B;
			else if (SEL==2) Y=C;
			else             Y=D;
		end
endmodule

/*
2.过程赋值语句
	y=b; 阻塞赋值
	y<=b; 非阻塞赋值

赋值语句中，左值与右值不同时。类型不同，则转化类型，长度不同，补长度，或者忽略左边的位数。
*/

// 16选1选择器
module mux61_1(
	input[3:0] sel,
	input[15:0] D,
	output Y);
	assign Y = D[sel];
endmodule
