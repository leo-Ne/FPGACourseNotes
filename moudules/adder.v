全加器设计
module h_adder(
	input A, B, 
	output SO, CO);
	assign SO = A ^ B;
	assign CO = A & B;
endmodule

module f_adder(ain, bin, cin, cout, sum);
	output cout, sum; input ain, bin, cin;
	wire net1, net2, net3;
	h_adder U1(ain, bin, net1, net2);
	h_adder U2(.A(net1), .SO(SUM), .B(cin), .CO(net3));
	or      U3(cout, net2, net3);
endmodule

元件例化：
引入一种连接关系，将预先设计好的设计模块定义为一个元件，然后利用特定的语句将此元件与当前的设计实体中指定端口相连接，从而为当前设计实体引入一个新的、低一级的设计层次。

(1)
<模块元件名>  <例化元件名> (.例化元件接口(例化元件外接端口))

<模块元件名>， 它具有唯一性。如果使用Verilog描述的模块，则是模块名，即元件名。
<例化元件名>： 在具体电路上模块被调用后放在不同的位置或担任不同的任务对应的名称。

理解： 模块元件名， MUX41， 例化元件名 MUX41类型的一个元器件。

(3)
端口名关联法:
<模块元件名>  <例化元件名> (.例化元件接口(例化元件外接端口))
位置不重要

位置关联法：
关联表述的信号位置十分重要，注意端口顺序，不能放错。
h_adder U1(ain, bin, net1, net2);


8位全加器设计及算术操作符

module ADDER8B (A, B, CIN, COUT, DOUT);
	output [7:0] DOUT; output COUT;
	input[7:0] A, B; input CIN;
	wire[8:0] DATA;
	assign DATA = A + B + CIN;
	assign COUT = DATA[8];
	assign COUT = DATA[7:0];
endmodule

module ADDER8B (A, B, CIN, COUT, DOUT);
	output [7:0] DOUT;
	output COUT;
	input [7:0] A, B;
	// 加操作的进位并入COT
	assign{COUT, DOUT} = A + B + CIN;
endmodule

算数运算
+ - * / % 等
分为有符号运算和无符号运算。(有符号运算时，需不需要转换成补码未知。)

测试代码：
module test1(A, B, C, D, RCD, RAB, RM1, RM2, S, CO, R1, R2);
	input [3:0] C, D; input signed [3:0] A, B;
	output [3:0] RCD; output [3:0] RAB;
	output [7:0] RM1; output [7:0] RM2;
	output [3:0] S; output CO; output R1, R2;
	reg signed [3:0] RAB; reg signed [7:0] RM2;
	reg R1, R2;
	always@(A, B, C, D) begin
		RCD <= C + D; RAB <= A+B;
		RM1 <= C*D;   RM2 <= A*B;
		{CO, S} <= {1'b0, C} - {1'b0, D};
		R1 <= (C>D); R2 <= (A>B);
	end
endmodule 

所有的算数运算都是按照无符号操作数进行的，如果是减法运算，输出结果是补码。
有符号数在进行运算之前，需要先定义为signed。有符号数的运算结果输出为数值的补码。



module BCD_ADDER(A, B, D);
	input [7:0] A, B; output [8:0] D;
	wire [4:0] DT0, DT1; reg [8:0] D; reg S;
	always@(DT0)
		begin 
			if (DT0[4:0] >= 5'b01010)
				begin D[3:0] = (DT0[3:0] + 4'b0110); S=1'b1; end;
			else
				begin D[3:0] = DT0[3:0]; S=1'b0; end
	end

	always@(DT1)
		begin
			if (DT1[4:0] >= 5'b01010)
				begin D[7:4] = DT1[3:0] + 4'b0110; D[8] = 1'b1; end
			else
				begin D[7:4] = Dt1[3:0] + 4'b0110; D[8] = 1'b0; end
	end
	
	assign DT0 = A[3:0] + B[3:0];
	assign Dt1 = A[7:4] + B[7:4] + S;
endmodule
有符号数与无符号数的比较怎么说？？？？




		

