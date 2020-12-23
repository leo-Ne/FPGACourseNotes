module h_adder (A, B, SO, CO);
	input A, B;
	output S0, CO;
	assign SO = A ^ B;
	assign CO = A & B;
endmodule


// 规范式的Verilog程序书写。
module h_adder(
	input A, B, 
	output SO, CO);
	assign SO = A ^ B;
	assign CO = A & B;
endmodule

/*
input 端口1， 端口2，。。。
output 端口1， 端口2，。。。。
inout 端口1， 端口2， 。。。。
input[msb: lsb] 端口1， 端口2， 。。。
output[3:0] C, D

2
逻辑操作符
& | ^ ~

与非 ~&
或非 ~|
同或 ~^

3
赋值语句：
assign 目标变量名 = 驱动表达式；
assign [延时] 目标变量名 = 驱动表达式；

4 
·timescale 10ns/100ps
assign #6 R1 = A & B;
延时6个时间单元赋值R1.


关键词：

标识符；

注释符与C++一致
//
 */
