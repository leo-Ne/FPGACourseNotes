/* 计数器 */

module CNT4 (CLK, Q);
	output Q;
	input CLK;
	reg[3:0] Q1;
	always@(posedge CLK)
		Q1 <= Q1 + 1;
	assign Q = Q1;
endmodule

module CNT4_1(CLK, Q);
	output Q;
	input CLK;
	reg[3:0] Q;
	always@(posedge CLK)
		Q = Q + 1;
endmodule

//可以组合的计数器
module CNT10(CLK, RST, EN, LOAD, COUT, DOUT, DATA);
	input CLK, EN, RST, LOAD;
	input reg [3:0] DATA;
	output[3:0] DOUT;
	output COUT;
	
	reg Q1; 
	reg COUT;
	assign DOUT=Q1;
	always@(posedge CLK or negedge RST) begin
		if(!RST) Q1 <= 0;
		else if(EN) begin
			if(!LOAD) Q1<=DATA;
			else if (Q1<9) Q1 <= Q1+1;
			else Q1<=4'b0000;
		end
	end
	always@(Q1)
		if(Q1==4'h9) cout=1'b1; 
		else 		 cout=1'b0;
endmodule
/* begin end 有什么作用？*/

// 异步清零、异步置数
module cnt10_async(
	input 	clk,
	input 	rst_n,
	input 	ld_n,
	input	[3:0] din,
	input 	en,
	output reg [3:0] q,
	output reg co
)
	always@(posedge clk or negedge rst_n or negedge ld_n) begin
		if(!rst_n) begin
			q<=0;
			cout<=1'b0;end
		else if(!ld_n) begin
			q<=din;end
		else begin
			if(en) begin
				if(q==4'd9) begin
					q<=0;
					co<=1'b1;end
				else begin
					q<=q+1;
					co<=0;end
			end
		end
	end
endmodule	































	
	
	
	
	
	
	
	
	