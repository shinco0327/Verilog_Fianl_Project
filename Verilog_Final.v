module Verilog_Final(left_btn, right_btn, function_btn, screen_row, screen_col, clk, out_state);
	input left_btn, right_btn, function_btn, clk;
	output reg[15:0]screen_row;
	output reg[31:0]screen_col;
	//reg [15:0]reg_screen_row;
	reg [3:0]screen_state;
	reg [9:0] timer;
	reg [4:0] human_col;
	wire [4:0]prn;
	wire easy_t, normal_t, extreme_t;
	reg [10:0] knife[15:0]; //[row_x, row_4, row_3, row_2, row_1, row_0, col_4, col_3, col_2, col_1, col_0]
	reg za_warudo;
	reg [15:0] za_warudo_t;
	output [3:0]out_state;
	parameter knife_size = 16;
	
	assign out_state = screen_state;
	//screen_map M0(screen_state, screen_col, reg_screen_row,  human_col);
	LFSR_5bit M1(clk, prn);
	drop_random M2(clk, easy_t, normal_t, extreme_t);


	always@(posedge clk) begin
		//update screen
		//##################################################################################
			if(screen_row == 16'b1000_0000_0000_0000) screen_row = 16'b0000_0000_0000_0001;
			else screen_row = {screen_row[14:0], 1'b0};
			//reg_screen_row = screen_row;
		//##################################################################################

		case(screen_state)
			//introduction
			0: begin
				integer i;
				for(i = 0; i < knife_size; i=i+1) knife[i] = 11'b111_1111_1111;
				if(function_btn) begin screen_state <= 1; timer = 0; end
				else screen_state <= 0;
			end
			//Main Game Mode
			1: begin 
				if(timer >= 250) begin
					integer i;
					timer = 0;
					//movement control of character
					if(right_btn)begin 
						if(human_col < 27) human_col = human_col + 1;
					end
					else if(left_btn)begin 
						if(human_col > 0 ) human_col = human_col - 1;
					end
					
					//generate new knife
					if(easy_t) begin
						create_knife();
					end
					
					if(!za_warudo) begin
						for(i=0; i<knife_size; i=i+1)begin		//knife go down
							if(knife[i] != 11'b111_1111_1111)begin
								if(knife[i][4:0] == 0) knife[i] = 11'b111_1111_1111;
								else knife[i][4:0] = knife[i][4:0] - 1;
								case(knife[i][4:0]) //detect got shot
									5'b00000: begin
										if(knife[i][9:5] == (human_col + 1)) screen_state <= 2;
										if(knife[i][9:5] == (human_col + 2)) screen_state <= 2; 
										if(knife[i][9:5] == (human_col + 3)) screen_state <= 2;  
									end
									5'b00001: begin
										
									end
									5'b00010: begin
										
									end
									5'b00011: begin
										if(knife[i][9:5] == (human_col)) screen_state <= 2;
										if(knife[i][9:5] == (human_col + 4)) screen_state <= 2; 
									end
									5'b00100: begin
										
									end
									5'b00101: begin
										
									end
								endcase 
							end
						end
					end
					else begin 
						za_warudo_t = za_warudo_t - 1;
						if(za_warudo_t == 0) za_warudo = 0; // toki wo ugokidasu
					end

				end
				else begin timer = timer+1;
					if(function_btn)begin   //za warudo  tomare toki wo
						za_warudo = 1;
						za_warudo_t = 16'h0fff;
					end
				end

			end
			2: begin
				if(function_btn) screen_state <= 0;
			end
			default: begin
				screen_state <= 0; 
				screen_row = 16'b0000_0000_0000_0001;
			end
		endcase	
	end

	//##################################################################################
	//##################################################################################
	//Draw the screen
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
			1: begin
				screen_col = 0;
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
					16'b0000_0000_0000_0001: begin
						knife_movement(4'b1111);
					end	
					16'b0000_0000_0000_0010: begin
						knife_movement(4'b1110);
					end	
					16'b0000_0000_0000_0100: begin
						knife_movement(4'b1101);
					end	
					16'b0000_0000_0000_1000: begin
						knife_movement(4'b1100);
					end	
					16'b0000_0000_0001_0000: begin
						knife_movement(4'b1011);
					end
					16'b0000_0000_0010_0000: begin
						knife_movement(4'b1010);
					end
					16'b0000_0000_0100_0000: begin
						knife_movement(4'b1001);
					end
					16'b0000_0000_1000_0000: begin
						knife_movement(4'b1000);
					end
					16'b0000_0001_0000_0000: begin
						knife_movement(4'b0111);
					end
					16'b0000_0010_0000_0000: begin
						knife_movement(4'b0110);
					end
					16'b0000_0100_0000_0000: begin
						knife_movement(4'b0101);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
						end	
					end
					16'b0000_1000_0000_0000: begin
						knife_movement(4'b0100);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
						end	
					end
					16'b0001_0000_0000_0000: begin
						knife_movement(4'b0011);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
						end	
					end
					16'b0010_0000_0000_0000: begin
						knife_movement(4'b0010);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 1;
							else if(human_col+1 == i) screen_col[i] = 0;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 0;
							else if(human_col+4 == i) screen_col[i] = 1;
						end	
					end
					16'b0100_0000_0000_0000: begin
						knife_movement(4'b0001);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 0;
							else if(human_col+1 == i) screen_col[i] = 1;
							else if(human_col+2 == i) screen_col[i] = 1;
							else if(human_col+3 == i) screen_col[i] = 1;
							else if(human_col+4 == i) screen_col[i] = 0;
						end	
					end
					16'b1000_0000_0000_0000: begin
						knife_movement(4'b0000);
						for(i=0; i<32; i=i+1) begin
							if(human_col == i) screen_col[i] = 1;
							else if(human_col+1 == i) screen_col[i] = 0;
							else if(human_col+2 == i) screen_col[i] = 0;
							else if(human_col+3 == i) screen_col[i] = 0;
							else if(human_col+4 == i) screen_col[i] = 1;
						end	
					end
					default: screen_col = 0;
				endcase
			end
			2: begin
				screen_col = 0;
				case(screen_row)
					16'b0000_0000_0000_0001: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0000_0000_0010: screen_col = 32'b0100_0000_0000_0000_0011_1111_1110_0000;
					16'b0000_0000_0000_0100: screen_col = 32'b0100_0000_0000_0000_0010_0000_0010_0000;
					16'b0000_0000_0000_1000: screen_col = 32'b0100_0000_0000_0000_0010_0000_0010_0000;
					16'b0000_0000_0001_0000: screen_col = 32'b0100_0000_0000_0000_0010_0000_0010_0000;
					16'b0000_0000_0010_0000: screen_col = 32'b0100_0000_0000_0000_0010_0000_0010_0000;
					16'b0000_0000_0100_0000: screen_col = 32'b0111_1111_1100_0000_0011_1111_1110_0000;
					16'b0000_0000_1000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					
					16'b0000_0001_0000_0000: screen_col = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
					16'b0000_0010_0000_0000: screen_col = 32'b0111_1111_1100_0000_0011_1111_1110_0000;
					16'b0000_0100_0000_0000: screen_col = 32'b0100_0000_0000_0000_0010_0000_0000_0000;
					16'b0000_1000_0000_0000: screen_col = 32'b0100_0000_0000_0000_0010_0000_0000_0000;
					16'b0001_0000_0000_0000: screen_col = 32'b0111_1111_1100_0000_0011_1111_1110_0000;
					16'b0010_0000_0000_0000: screen_col = 32'b0000_0000_0100_0000_0010_0000_0000_0000;
					16'b0100_0000_0000_0000: screen_col = 32'b0111_1111_1100_0000_0011_1111_1110_0000;
					16'b1000_0000_0000_0000: screen_col = 32'hFFFF_FFFF;
				endcase
			end
			default: begin
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
		endcase
	end
	//##################################################################################
	//##################################################################################
	//Set screen_row initial value
	
	initial begin
		integer i;
		screen_row = 16'h0001;
		//screen_state = 0;
		for(i = 0; i < knife_size; i=i+1) knife[i] = 11'b111_1111_1111;
	end
	
	//##################################################################################
	//##################################################################################
	task knife_movement;
		input [3:0]position;
		integer i;
		for(i=0; i< knife_size; i=i+1)begin
			if(knife[i] != 11'b111_1111_1111)begin
				if((position + 2) < 4'hf) if(knife[i][4:0] == position+2) screen_col[knife[i][9:5]] = 1;
				if((position + 1) < 4'hf) if(knife[i][4:0] == position+1) screen_col[knife[i][9:5]] = 1;
				if(knife[i][4:0] == position) screen_col[knife[i][9:5]] = 1;
			end
		end
	endtask
	//##################################################################################
	//##################################################################################

	task create_knife;
		if(knife[0] == 11'b111_1111_1111) begin
			knife[0][10:5] = {1'b0, prn[4:0]};
			knife[0][4:0] = {4'hf};
		end	
		else if(knife[1] == 11'b111_1111_1111) begin
			knife[1][10:5] = {1'b0, prn[4:0]};
			knife[1][4:0] = {4'hf};
		end	
		else if(knife[2] == 11'b111_1111_1111) begin
			knife[2][10:5] = {1'b0, prn[4:0]};
			knife[2][4:0] = {4'hf};
		end	
		else if(knife[3] == 11'b111_1111_1111) begin
			knife[3][10:5] = {1'b0, prn[4:0]};
			knife[3][4:0] = {4'hf};
		end	
		else if(knife[4] == 11'b111_1111_1111) begin
			knife[4][10:5] = {1'b0, prn[4:0]};
			knife[4][4:0] = {4'hf};
		end	
		else if(knife[5] == 11'b111_1111_1111) begin
			knife[5][10:5] = {1'b0, prn[4:0]};
			knife[5][4:0] = {4'hf};
		end	
		else if(knife[6] == 11'b111_1111_1111) begin
			knife[6][10:5] = {1'b0, prn[4:0]};
			knife[6][4:0] = {4'hf};
		end	
		else if(knife[7] == 11'b111_1111_1111) begin
			knife[7][10:5] = {1'b0, prn[4:0]};
			knife[7][4:0] = {4'hf};
		end	
		else if(knife[8] == 11'b111_1111_1111) begin
			knife[8][10:5] = {1'b0, prn[4:0]};
			knife[8][4:0] = {4'hf};
		end	
		else if(knife[9] == 11'b111_1111_1111) begin
			knife[9][10:5] = {1'b0, prn[4:0]};
			knife[9][4:0] = {4'hf};
		end	
		else if(knife[10] == 11'b111_1111_1111) begin
			knife[10][10:5] = {1'b0, prn[4:0]};
			knife[10][4:0] = {4'hf};
		end	
		else if(knife[11] == 11'b111_1111_1111) begin
			knife[11][10:5] = {1'b0, prn[4:0]};
			knife[11][4:0] = {4'hf};
		end	
		else if(knife[12] == 11'b111_1111_1111) begin
			knife[12][10:5] = {1'b0, prn[4:0]};
			knife[12][4:0] = {4'hf};
		end	
		else if(knife[13] == 11'b111_1111_1111) begin
			knife[13][10:5] = {1'b0, prn[4:0]};
			knife[13][4:0] = {4'hf};
		end	
		else if(knife[14] == 11'b111_1111_1111) begin
			knife[14][10:5] = {1'b0, prn[4:0]};
			knife[14][4:0] = {4'hf};
		end	
		else if(knife[15] == 11'b111_1111_1111) begin
			knife[15][10:5] = {1'b0, prn[4:0]};
			knife[15][4:0] = {4'hf};
		end	 /*
		else if(knife[16] == 11'b111_1111_1111) begin
			knife[16][10:5] = {1'b0, prn[4:0]};
			knife[16][4:0] = {4'hf};
		end	
		else if(knife[17] == 11'b111_1111_1111) begin
			knife[17][10:5] = {1'b0, prn[4:0]};
			knife[17][4:0] = {4'hf};
		end	
		else if(knife[18] == 11'b111_1111_1111) begin
			knife[18][10:5] = {1'b0, prn[4:0]};
			knife[18][4:0] = {4'hf};
		end	
		else if(knife[19] == 11'b111_1111_1111) begin
			knife[19][10:5] = {1'b0, prn[4:0]};
			knife[19][4:0] = {4'hf};
		end	 */
	endtask
endmodule

