// Shift register

//1.同步预置功能的移位寄存器
module SHFT1(CLK, LOAD, DIN, QB);
	output QB;
	input CLK, LOAD;
	input [7:0] DIN;
	reg[7:0] REG8;
	always@(posedge CLK)
		if(LOAD)	REG8<=DIN;
		else 		REG8[6:0]<=REG8[7:1];
	assign QB=REG8[0];
endmodule


//2. 使用位移操作符设计寄存器
module SHFT4(DIN, CLK, RST, DOUT)
	input CLK, DIN, RST;
	output DOUT;
	reg [3:0] SHFT;
	always@(posedge CLK or negedge RST)
	if(RST) SHFT<=4'B0;
	else begin SHFT<=(SHFT>>1);SHFT<=DIN;end
endmodule

//4位双向移位寄存器
/*
rd_n 	S 	clk 		q
0		~ 	~ 		清零
1 		00 	up 		保持
1 		01 	up 		右移
1 		10 	up 		左移
1 		11 	up  		并行置数
*/

module shifter_194(
	input 	rd_n,
	input 	clk,
	input 	[0:3] d,
	input  	dir,
	input 	dil,
	input 	[1:0] s,
	output [0:3] q
);
	always@(negedge rd_n or posedge clk)
		if(rd_n==1'b0)
			q<=0;
		else
			case(s)
				2'b00: q[0:3]<=q[0:3];  	  //保持
				2'b01: q[0:3]<={dir, q[0:2]}; // 右移
				2'b10: q[0:3]<={q[1:3], dil}; // 左移
				2'b11: q[0:3]<=d;			  // 置数
				default:q[0:3]<=q[0:3];		  //保持
			endcase
endmodule


// shifter 74LS595
module shifter_595(
	input	sck,
	input 	sld,
	input	sclr,
	input 	lck,
	input 	oe,
	output wire [7:0] q,
	output wire qh
);
	reg [7:0] q_tmp;
	reg [7:0] q_latch;
	
	always@(posedge sck or negedge sclr)
		if(sclr==1'b0)
			q_tmp<=8'b0;
		else
			q_tmp<={q_tmp[6:0], sdl};
		
	always@(posedge lck or negedge sclr)
		if(sclr==1'b0)
			q_latch<=8'b00;
		else
			q_latch<=q_tmp;
	
	assign qh=q_tmp[7];
	assign q=(oe==1'b0) ? q_latch:8'bzzzzzzzz;
endmodule

// 16bits 串入并出移位寄存器
// 串行右移转并行输出
module shifter_slp16(
	input clk,
	input reset_n,
	input serial_in,
	input reg[15:0] parallel_out
);
	always@(posedge clk or negedge reset_n)
		if(!reset_n)
			parallel_out<=0;
		else
			parallel_out<={serial_in, parallel_out[15:1]};
endmodule

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	



















