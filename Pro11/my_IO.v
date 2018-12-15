module my_IO(
	input clk,
	input clk_ram,
	inout 		   PS2_CLK,
	inout 		  	PS2_DAT,
	output hsync, // 行同步和列同步信号
	output vsync,
	output valid, //消隐信号
	output [7:0] vga_r, // 红绿蓝颜色信号
	output [7:0] vga_g,
	output [7:0] vga_b,
	output vga_clk,
	output sync_n,
	output [9:0] h_addr,// 提供给上层模块的当前扫描像素点坐标
	output [9:0] v_addr,
	output reg debug,
	output [11:0]raddr,
	output [11:0]waddr,
	output [11:0]fontaddr,
	output black,
	input reset,
	output w_clk,
	output [7:0] keybddata,
	output reg [7:0]count
);
	reg [6:0] new_ascii;
	reg [11:0] gm_write_addr;
	
	reg [3:0]red;
	reg [3:0]green;
	reg [3:0]blue;
	//wire [11:0]raddr;	
	reg [31:0]wcount;	
	reg [11:0]romaddr;
	
	wire [8:0]char;
	wire [3:0]point;
	wire [6:0]x_addr;
	//wire black;
	wire [7:0] ascii_data;
	//wire [7:0] keybddata;
	wire [7:0]font_ascii;
	reg [7:0]data_buf;
	reg wren;
	//wire w_clk;
	reg [4:0] first;
	wire cur_clk;
	wire game_clk;
	wire rel_clk;
	//reg [8:0] dis;
	reg [8:0]offset[69:0];
	reg [6:0] offset_point;
	//wire[8:0] dis_val;
	wire [9:0] new;
	
	reg flag;
	reg ran_en;
	initial ran_en=0;
	initial offset_point=0;
	initial wren =0;
	initial new_ascii = 0;
	initial gm_write_addr =0;
	initial flag  = 0;
	initial data_buf =0;
	initial first=0;
	initial debug=0;
	initial wcount=32'd0;
	initial count =0;
	assign sync_n = 0;
	assign waddr = wcount[11:0];
	assign new=((v_addr>offset[x_addr])?(v_addr-offset[x_addr]):(v_addr+480-offset[x_addr]));
	assign raddr =  ({2'b00,new-1} >> 4)*12'd70 + {2'b00,h_addr-1}/12'd9;
	assign fontaddr = romaddr*16+ (new[3:0]-1);
	assign point =  (h_addr-1)%9;
	assign x_addr=(h_addr-1)/9;
	assign black = h_addr>630 ? 0: char[point-1];

	
	
	//dis dis_module(.rdaddress(point),.wraddress(dis_counter),.clock(rel_clk),.q(dis_val),.wren(1),.data(data_buf));	
	always @(posedge rel_clk)
		if(offset_point<69)
			offset_point<=offset_point+1;
		else
			offset_point=0;
			
	always @(posedge rel_clk)
	begin
	if(offset[offset_point]<480)
		offset[offset_point]=offset[offset_point]+offset_point%6+1;
	else
		offset[offset_point]=0; 
  end
	

wire [19:0] m_seq;
m_sequence my_seq(vga_rand,reset,m_seq);
reg [31:0]w_clk_count;
 always @(posedge vga_clk) 
	if(w_clk_count < 25000000)
		begin
			w_clk_count = w_clk_count +1;
			ran_en =0;
		end
	else
		begin
			w_clk_count = 0;
			ran_en =1;
		end
	
always @ (posedge vga_clk)
begin
		if(flag == 1)
		begin
			new_ascii<=0;
			gm_write_addr = raddr;
		end
		else if(new[3:0]==1&& m_seq[2:0]==0 && ran_en)
		begin
			new_ascii<=97+m_seq%26;
			gm_write_addr=70 + ({2'b00,(10'd480-offset[x_addr]-1)}>>4)*12'd70 + {2'b00,h_addr-1}/12'd9;
		end
		else
		begin
			new_ascii<=0;
			gm_write_addr=({2'b00,(10'd480-offset[x_addr]-1)}>>4)*12'd70 + {2'b00,h_addr-1}/12'd9;
		end
end
always @ (posedge vga_clk)
	if(ascii_data != 8'h00)
		begin
			if(font_ascii == ascii_data)
				begin
					flag = 1;
					count = count+1;
				end
			else
				flag = 0;	
		end
	 else
		begin
			flag = 0;
		end
			
 always @ (font_ascii)
	case(font_ascii)
	8'h01:romaddr = 12'd0;
	8'h30:romaddr = 12'd48;
	8'h31:romaddr = 12'd49;
	8'h32:romaddr = 12'd50;
	8'h33:romaddr = 12'd51;
	8'h34:romaddr = 12'd52;
	8'h35:romaddr = 12'd53;
	8'h36:romaddr = 12'd54;
	8'h3e:romaddr = 12'd62;
	8'h5f:romaddr = 12'd95;
	8'h37:romaddr = 12'd55;
	8'h38:romaddr = 12'd56;
	8'h39:romaddr = 12'd57;
	8'h61:romaddr = 12'd97;
	8'h62:romaddr = 12'd98;
	8'h63:romaddr = 12'd99;
	8'h64:romaddr = 12'd100;
	8'h65:romaddr = 12'd101;
	8'h66:romaddr = 12'd102;
	8'h67:romaddr = 12'd103;
	8'h68:romaddr = 12'd104;
	8'h69:romaddr = 12'd105;
	8'h6a:romaddr = 12'd106;
	8'h6b:romaddr = 12'd107;
	8'h6c:romaddr = 12'd108;
	8'h6d:romaddr = 12'd109;
	8'h6e:romaddr = 12'd110;
	8'h6f:romaddr = 12'd111;
	8'h70:romaddr = 12'd112;
	8'h71:romaddr = 12'd113;
	8'h72:romaddr = 12'd114;
	8'h73:romaddr = 12'd115;
	8'h74:romaddr = 12'd116;
	8'h75:romaddr = 12'd117;
	8'h76:romaddr = 12'd118;
	8'h77:romaddr = 12'd119;
	8'h78:romaddr = 12'd120;
	8'h79:romaddr = 12'd121;
	8'h7a:romaddr = 12'd122;
	default:romaddr = 12'd0;
	endcase	
	
always  @ (black)
	case(black)
	1'b0:begin red=4'b0000;green=4'b0000;blue=4'b0000; end
	1'b1:begin red=4'b1111;green=4'b1111;blue=4'b1111; end
	endcase
transfer transasc(keybddata,ascii_data);
	
	wire vga_rand;
	
clkgen #(25000000) clk6(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(vga_rand));
	
clkgen #(25000000) clk1(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(vga_clk));

clkgen #(10) clk2(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(w_clk));

clkgen #(1) clk3(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(cur_clk));

clkgen #(10) clk4(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(game_clk));

clkgen #(1400) clk5(.clkin(clk),.rst(1'b0),.clken(1'b1),.clkout(rel_clk));

picture ram(.rdaddress(raddr),.wraddress(gm_write_addr),.clock(clk_ram),.q(font_ascii),.wren(1),.data(new_ascii));

vga_font rom(.address(fontaddr),.q(char),.clock(clk_ram));

ps2_keyboard keyboard(clk,1'b1,PS2_CLK,PS2_DAT,keybddata);

vga_ctrl vga(.pclk(vga_clk),.reset(reset),
.vga_data({red,4'b0000,green,4'b0000,blue,4'b0000}),
	.h_addr(h_addr),
	.v_addr(v_addr),
	.hsync(hsync),
	.vsync(vsync),
	.valid(valid),
	.vga_r(vga_r),
	.vga_g(vga_g),
	.vga_b(vga_b));
endmodule
