// D-Latch
// D锁存器

/* teacher's code */
module LATCH(CLK, D, Q);
	output reg Q;
	input CLK, D;
	always@(D or CLK) begin
		if(CLK) Q<=D;
	end
endmodule

/* 锁存器定义
* 当CLK位高电平时，输出Q才随D输入的数据而改变
* 而当CLK位低电平时将保存其在高电平时锁入的数据。这就意味着需要引入储存元件于设计模式中。
*/

/* 含清零控制的锁存器 */
module LATCH2(CLK, D, Q, RST);
	output Q;
	input CLK, D, RST;
	assign Q=(!RST) ? 0:(CLK ? D:Q);
endmodule

module LATCH3(CLK, D, Q, RST);
	output Q;
	input CLK, D, RST;
	reg Q;
	always@(D or CLK or RST) begin
		if(!RST) Q<=0;
		else if(CLK) Q<=D;
	end
endmodule



/* 同步和异步
* 异步时序电路的Verilog表述特点
* 时钟过程表述的特点和规律 
*/

/* 同步
在数字电路中，同步是指输入信号和时钟有关，输入信号依赖于时钟*/
/*异步
异步是指输入信号和时钟无关，输入信号不依赖与时钟*/

/* 异步时序电路在verilog表述中，没有单一主控时钟。
*/

/* 信号的边缘敏感，信号的电平敏感 */
/* 控制信号， 变量类型的信号 */

/* 边沿触发型时序模块的Verilog设计，可以遵循以下几个规律*/

/*
* （1）如果将信号A定义为边缘敏感时钟信号，则必须在敏感信号列表中给出对应的表述，如possdge A或negedge A; 但在always过程结构中不能再出现信号A了。
* （2）若将信号B定义位对应与时钟的电平敏感信号的异步控制信号(或仅仅时异步输入信号），则除了在敏感信号表中给出对应的表述外，在always过程结构中必须表明信号B的逻辑行为。
* （3）若某信号定义为对应时钟的同步控制信号（或仅仅是同步输入信号），则绝不可以以任何形式出现在敏感信号表中。
* （4）敏感信号列表中不允许出现混合信号。敏感信号表一旦含有posedge或者negedge的边缘信号后，所有器它普通变量都不能放在敏感信号表中。
*      eeror eg. always@(posedge CLK or RST) 或 always@(posedge CLK or negedge RST or A)
* （5）若定义某变量为异步低电平敏感信号，则在if条件语句中应该对敏感信号表中有匹配的表述。
* （6）不允许在敏感信号表中定义除了异步时序控制信号以外的信号。
*/




