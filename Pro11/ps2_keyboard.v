module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data);
	input clk,clrn,ps2_clk,ps2_data;
	output reg[7:0] data;
	//output 
	reg[11:0]count0=0;
 // internal signal, for test
   reg[9:0] buffer; // ps2_data bits
	reg [7:0] fifo[7:0]; // data fifo
	reg [2:0] w_ptr,r_ptr; // fifo write and read pointers
	reg [3:0] count; // count ps2_data bits
// detect falling edge of ps2_clk
	reg [2:0] ps2_clk_sync;
	reg ready;
	reg overflow;
	initial data = 8'hff;
 always @(posedge clk) 
	begin
		ps2_clk_sync <= {ps2_clk_sync[1:0],ps2_clk};
	end

	wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

 always @(posedge clk) 
 begin
	if (clrn == 0)
		begin // reset
			count <= 0; w_ptr <= 0; r_ptr <= 0;
			overflow <= 0; ready<= 0;
			 count0<=0;
		end 
	else if (sampling)
		begin
		if (count == 4'd10) begin
			if ((buffer[0] == 0) && // start bit
				(ps2_data) && // stop bit
				(^buffer[9:1])) 
				begin // odd parity
		fifo[w_ptr] <= buffer[8:1]; // kbd scan code	
		if(data == 8'hf0)
		fifo[w_ptr] <= 8'hff;
		//w_ptr <= w_ptr+3'b1;
		if(fifo[w_ptr]!=8'hf0 && fifo[w_ptr]!=8'hff&&data!=fifo[w_ptr])
			begin
				count0 <= count0 +1;
			end
		ready <= 1'b1;
		overflow <= overflow | (r_ptr == (w_ptr + 3'b1));
		end
		count <= 0; // for next
		end else begin
		buffer[count] <= ps2_data; // store ps2_data
		count <= count + 3'b1;
		end
	end
  if (ready) 
  /*
	begin 
	if(fifo[w_ptr]!=8'hf0 && fifo[w_ptr]!=8'hff && data != fifo[w_ptr])
			begin
				count0 <= count0 +1;
				if(count0 == 9)
				begin 
					count0 <=0;
					count1 <= count1 +1;
				if(count1 == 9)
				begin
					count1 <= 0;
				end
		end
	end					// read to output next data
	*/
			data = fifo[w_ptr];
	end		
  endmodule