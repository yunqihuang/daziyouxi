module m_sequence(
	input				sclk,
	input				rst_n,
	output [19:0] m_seq
);
//parameter POLY = 8'b10001110;//由本原多项式得到

reg [19:0]	shift_reg;
//wire nor_res;
//assign nor_res=!(shift_reg[1]|shift_reg[2]|shift_reg[3]|shift_reg[4]|shift_reg[5]|shift_reg[6]|shift_reg[7]);

always@(posedge sclk or posedge rst_n)
begin
	if(rst_n == 1'b1)begin
		shift_reg <= 20'b11111111111111111111;//初值不可为全零
		end
	else begin
		//shift_reg[0]<=((shift_reg[7]^shift_reg[3])^shift_reg[2])^shift_reg[1];
		/*shift_reg[7] <=  (shift_reg[0] & POLY[7])^
						(shift_reg[1] & POLY[6])^
						(shift_reg[2] & POLY[5])^
						(shift_reg[3] & POLY[4])^
						(shift_reg[4] & POLY[3])^
						(shift_reg[5] & POLY[2])^
						(shift_reg[6] & POLY[1])^
						(shift_reg[7] & POLY[0]);*/
		//shift_reg[7:1] <= shift_reg[6:0];	
			//shift_reg<=8'b01000001;
			
			if(shift_reg==0)
				shift_reg=20'b10000000000000000000;
			else
			begin
			shift_reg[18:0]<=shift_reg[19:1];
			shift_reg[19]<=(shift_reg[3]^shift_reg[0]);//^nor_res;
			end
		end
end

assign m_seq = shift_reg[19:0];

endmodule
