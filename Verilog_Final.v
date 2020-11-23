module Verilog_Final(left_btn, right_btn, function_btn, screen_row, screen_col, clk);
	input left_btn, right_btn, function_btn, clk;
	output reg[15:0]screen_row;
	output [31:0]screen_col;
	reg [15:0]reg_screen_row;
	reg [3:0]screen_state;
	reg [9:0] timer;
	reg [4:0] human_col;

	screen_map M0(screen_state, screen_col, reg_screen_row,  human_col);


	always@(posedge clk) begin
		//update screen
		//##################################################################################
			if(screen_row == 16'b1000_0000_0000_0000) screen_row = 16'b0000_0000_0000_0001;
			else screen_row = {screen_row[14:0], 1'b0};
			reg_screen_row = screen_row;
		//##################################################################################

		if(timer == 1000) begin
			screen_state = 1;
			timer = 0;
			if(right_btn)begin 
				if(human_col < 27) human_col = human_col + 1;
			end
			if(left_btn)begin 
				if(human_col > 0 ) human_col = human_col - 1;
			end
		end

		timer = timer +1;
		
	end

	//Set screen_row initial value
	initial begin
		screen_row = 16'h0001;
	end
endmodule

module screen_map(screen_state, screen_col, screen_row, human_col);
	input screen_state;
	input [15:0]screen_row;
	output reg[31:0]screen_col;
	input [4:0] human_col;
	
	always @(screen_row) begin
		integer i;

		case(screen_state)
			0: begin
				case(screen_row)
					16'b0000_0000_0000_0001: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0000_0010: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0000_0100: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0000_1000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0001_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0010_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_0100_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0000_1000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0001_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0010_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_0100_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0000_1000_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0001_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0010_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b0100_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
					16'b1000_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
				endcase
			end
			default: begin
				case(screen_row)
					/*
					16'b0000_0000_0000_0001: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_0010: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_0100: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_1000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0001_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0010_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0100_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_1000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0001_0000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0010_0000_0000: screen_col = 32'b0000_0000_0000_0011_1000_0000_0000_0000;
					16'b0000_0100_0000_0000: screen_col = 32'b0000_0000_0000_0011_1000_0000_0000_0000;
					16'b0000_1000_0000_0000: screen_col = 32'b0000_0000_0000_0011_1000_0000_0000_0000;
					16'b0001_0000_0000_0000: screen_col = 32'b0000_0000_0000_0101_0100_0000_0000_0000;
					16'b0010_0000_0000_0000: screen_col = 32'b0000_0000_0000_0011_1000_0000_0000_0000;
					16'b0100_0000_0000_0000: screen_col = 32'b0000_0000_0000_0100_0100_0000_0000_0000;
					16'b1000_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
					*/
					16'b0000_0000_0000_0001: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_0010: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_0100: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_1000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0001_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0010_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0100_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_1000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0001_0000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0010_0000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0100_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
							else screen_col[i] = 0;
						end	
					end
					16'b0000_1000_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
							else screen_col[i] = 0;
						end	
					end
					16'b0001_0000_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
							else screen_col[i] = 0;
						end	
					end
					16'b0010_0000_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 1;
							else if(human_col+1 == i) screen_col[i] = 0;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 0;
							else if(human_col+4 == i) screen_col[i] = 1;
							else screen_col[i] = 0;
						end	
					end
					16'b0100_0000_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
							else screen_col[i] = 0;
						end	
					end
					16'b1000_0000_0000_0000: begin
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 1;
							else if(human_col+1 == i) screen_col[i] = 0;
							else if(human_col+2 == i) screen_col[i] = 0;
							else if(human_col+3 == i) screen_col[i] = 0;
							else if(human_col+4 == i) screen_col[i] = 1;
							else screen_col[i] = 0;
						end	
					end
				endcase
			end

		endcase
	end 

endmodule