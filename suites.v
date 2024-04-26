module suites_rom
	(
		input wire clk,
		input wire [2:0] row,
		input wire [2:0] col,
		input [5:0] card,
		output reg [11:0] color_data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [2:0] row_reg;
	reg [2:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end

	always @(*) begin
		if(card / 13 == 3)begin //Clubs
			if(({row_reg, col_reg}==6'b000000)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b000001)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}>=6'b000010) && ({row_reg, col_reg}<6'b000100)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b000100)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b000101)) color_data = 12'b111111111111;

			if(({row_reg, col_reg}>=6'b000110) && ({row_reg, col_reg}<6'b001001)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b001001)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b001010)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b001011)) color_data = 12'b000100000010;
			if(({row_reg, col_reg}==6'b001100)) color_data = 12'b001000010001;
			if(({row_reg, col_reg}==6'b001101)) color_data = 12'b111111101110;

			if(({row_reg, col_reg}>=6'b001110) && ({row_reg, col_reg}<6'b010001)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b010001)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}>=6'b010010) && ({row_reg, col_reg}<6'b010100)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b010100)) color_data = 12'b000100000001;

			if(({row_reg, col_reg}>=6'b010101) && ({row_reg, col_reg}<6'b011000)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b011000)) color_data = 12'b001000000000;
			if(({row_reg, col_reg}==6'b011001)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b011010)) color_data = 12'b111111011111;
			if(({row_reg, col_reg}==6'b011011)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b011100)) color_data = 12'b111111101111;

			if(({row_reg, col_reg}>=6'b011101) && ({row_reg, col_reg}<6'b100000)) color_data = 12'b000100000001;
			if(({row_reg, col_reg}>=6'b100000) && ({row_reg, col_reg}<6'b100010)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b100010)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b100011)) color_data = 12'b001000000100;
			if(({row_reg, col_reg}==6'b100100)) color_data = 12'b001000010100;

			if(({row_reg, col_reg}>=6'b100101) && ({row_reg, col_reg}<6'b101000)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b101000)) color_data = 12'b001000000001;
			if(({row_reg, col_reg}==6'b101001)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b101010)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b101011)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b101100)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b101101)) color_data = 12'b001000010010;

			if(({row_reg, col_reg}==6'b101110)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b110000)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b110001)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b110010)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b110011)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b110100)) color_data = 12'b111111111111;

			if(({row_reg, col_reg}>=6'b110101) && ({row_reg, col_reg}<6'b111000)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b111000)) color_data = 12'b111111101101;
			if(({row_reg, col_reg}==6'b111001)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b111010)) color_data = 12'b001000010001;
			if(({row_reg, col_reg}==6'b111011)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b111100)) color_data = 12'b000100000000;
			if(({row_reg, col_reg}==6'b111101)) color_data = 12'b111111111110;

			if(({row_reg, col_reg}>=6'b111110) && ({row_reg, col_reg}<=6'b111110)) color_data = 12'b111111111101;
		end
		else if(card / 13 == 2)begin // Diamonds
			if(({row_reg, col_reg}==6'b000000)) color_data = 12'b110011111110;
			if(({row_reg, col_reg}==6'b000001)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b000010)) color_data = 12'b111110111101;
			if(({row_reg, col_reg}==6'b000011)) color_data = 12'b110000100011;
			if(({row_reg, col_reg}==6'b000100)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b000101)) color_data = 12'b111111111101;

			if(({row_reg, col_reg}==6'b000110)) color_data = 12'b111011111110;
			if(({row_reg, col_reg}==6'b001000)) color_data = 12'b111111111101;
			if(({row_reg, col_reg}==6'b001001)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b001010)) color_data = 12'b110100100011;
			if(({row_reg, col_reg}==6'b001011)) color_data = 12'b111000010011;
			if(({row_reg, col_reg}==6'b001100)) color_data = 12'b101100100010;
			if(({row_reg, col_reg}==6'b001101)) color_data = 12'b111111011101;

			if(({row_reg, col_reg}==6'b001110)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b010000)) color_data = 12'b111111001101;
			if(({row_reg, col_reg}==6'b010001)) color_data = 12'b110000110011;
			if(({row_reg, col_reg}==6'b010010)) color_data = 12'b110100010001;
			if(({row_reg, col_reg}>=6'b010011) && ({row_reg, col_reg}<6'b010101)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b010101)) color_data = 12'b110000100010;

			if(({row_reg, col_reg}==6'b010110)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b011000)) color_data = 12'b110100010011;
			if(({row_reg, col_reg}==6'b011001)) color_data = 12'b111000010010;
			if(({row_reg, col_reg}==6'b011010)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}>=6'b011011) && ({row_reg, col_reg}<6'b011101)) color_data = 12'b111100000001;
			if(({row_reg, col_reg}==6'b011101)) color_data = 12'b111100010010;

			if(({row_reg, col_reg}==6'b011110)) color_data = 12'b110000100011;
			if(({row_reg, col_reg}==6'b100000)) color_data = 12'b110100010011;
			if(({row_reg, col_reg}==6'b100001)) color_data = 12'b111000010010;
			if(({row_reg, col_reg}==6'b100010)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}>=6'b100011) && ({row_reg, col_reg}<6'b100101)) color_data = 12'b111100000001;
			if(({row_reg, col_reg}==6'b100101)) color_data = 12'b111100010010;

			if(({row_reg, col_reg}==6'b100110)) color_data = 12'b110000100011;
			if(({row_reg, col_reg}==6'b101000)) color_data = 12'b111111001101;
			if(({row_reg, col_reg}==6'b101001)) color_data = 12'b110000110011;
			if(({row_reg, col_reg}==6'b101010)) color_data = 12'b110100010010;
			if(({row_reg, col_reg}>=6'b101011) && ({row_reg, col_reg}<6'b101101)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b101101)) color_data = 12'b110000100011;

			if(({row_reg, col_reg}==6'b101110)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b110000)) color_data = 12'b111111101101;
			if(({row_reg, col_reg}==6'b110001)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}>=6'b110010) && ({row_reg, col_reg}<6'b110100)) color_data = 12'b110100100011;
			if(({row_reg, col_reg}==6'b110100)) color_data = 12'b101100100011;
			if(({row_reg, col_reg}==6'b110101)) color_data = 12'b111111011101;

			if(({row_reg, col_reg}==6'b110110)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b111000)) color_data = 12'b110111111110;
			if(({row_reg, col_reg}==6'b111001)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b111010)) color_data = 12'b111110111101;
			if(({row_reg, col_reg}==6'b111011)) color_data = 12'b110000100011;
			if(({row_reg, col_reg}==6'b111100)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b111101)) color_data = 12'b111111101101;

			if(({row_reg, col_reg}>=6'b111110) && ({row_reg, col_reg}<=6'b111110)) color_data = 12'b111111111110;
		end
		else if(card / 13 == 1)begin // Hearts
			if(({row_reg, col_reg}==6'b000000)) color_data = 12'b111110111101;
			if(({row_reg, col_reg}==6'b000001)) color_data = 12'b110000100011;
			if(({row_reg, col_reg}==6'b000010)) color_data = 12'b110000100010;
			if(({row_reg, col_reg}==6'b000011)) color_data = 12'b111110111011;
			if(({row_reg, col_reg}==6'b000100)) color_data = 12'b111100000010;
			if(({row_reg, col_reg}==6'b000101)) color_data = 12'b111100010011;

			if(({row_reg, col_reg}==6'b000110)) color_data = 12'b111111001100;
			if(({row_reg, col_reg}==6'b001000)) color_data = 12'b111000010011;
			if(({row_reg, col_reg}==6'b001001)) color_data = 12'b110100010010;
			if(({row_reg, col_reg}==6'b001010)) color_data = 12'b111000100010;
			if(({row_reg, col_reg}==6'b001011)) color_data = 12'b111100010001;
			if(({row_reg, col_reg}==6'b001100)) color_data = 12'b111100000010;
			if(({row_reg, col_reg}==6'b001101)) color_data = 12'b111100010010;

			if(({row_reg, col_reg}==6'b001110)) color_data = 12'b110100100011;
			if(({row_reg, col_reg}==6'b010000)) color_data = 12'b111000010010;
			if(({row_reg, col_reg}==6'b010001)) color_data = 12'b111000010001;
			if(({row_reg, col_reg}==6'b010010)) color_data = 12'b111100010001;
			if(({row_reg, col_reg}==6'b010011)) color_data = 12'b111100000000;
			if(({row_reg, col_reg}==6'b010100)) color_data = 12'b111100010001;
			if(({row_reg, col_reg}==6'b010101)) color_data = 12'b111100000001;

			if(({row_reg, col_reg}==6'b010110)) color_data = 12'b111100000010;
			if(({row_reg, col_reg}>=6'b011000) && ({row_reg, col_reg}<6'b011010)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b011010)) color_data = 12'b111100000000;
			if(({row_reg, col_reg}==6'b011011)) color_data = 12'b111100010001;
			if(({row_reg, col_reg}==6'b011100)) color_data = 12'b111100000001;
			if(({row_reg, col_reg}==6'b011101)) color_data = 12'b111100000010;

			if(({row_reg, col_reg}==6'b011110)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b100000)) color_data = 12'b110100010010;
			if(({row_reg, col_reg}==6'b100001)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b100010)) color_data = 12'b111100010001;
			if(({row_reg, col_reg}>=6'b100011) && ({row_reg, col_reg}<6'b100101)) color_data = 12'b111100000001;
			if(({row_reg, col_reg}==6'b100101)) color_data = 12'b111000010010;

			if(({row_reg, col_reg}==6'b100110)) color_data = 12'b110100010010;
			if(({row_reg, col_reg}==6'b101000)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b101001)) color_data = 12'b101100100010;
			if(({row_reg, col_reg}==6'b101010)) color_data = 12'b110100010010;
			if(({row_reg, col_reg}==6'b101011)) color_data = 12'b111100010010;
			if(({row_reg, col_reg}==6'b101100)) color_data = 12'b111000010010;
			if(({row_reg, col_reg}==6'b101101)) color_data = 12'b110000100011;

			if(({row_reg, col_reg}==6'b101110)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b110000)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b110001)) color_data = 12'b111111011101;
			if(({row_reg, col_reg}==6'b110010)) color_data = 12'b110100100011;
			if(({row_reg, col_reg}==6'b110011)) color_data = 12'b111000100011;
			if(({row_reg, col_reg}==6'b110100)) color_data = 12'b101100100010;
			if(({row_reg, col_reg}==6'b110101)) color_data = 12'b111111011101;

			if(({row_reg, col_reg}==6'b110110)) color_data = 12'b111111101101;
			if(({row_reg, col_reg}==6'b111000)) color_data = 12'b110011111110;
			if(({row_reg, col_reg}==6'b111001)) color_data = 12'b111111101101;
			if(({row_reg, col_reg}==6'b111010)) color_data = 12'b111110111101;
			if(({row_reg, col_reg}==6'b111011)) color_data = 12'b110100010011;
			if(({row_reg, col_reg}==6'b111100)) color_data = 12'b111111011101;

			if(({row_reg, col_reg}>=6'b111101) && ({row_reg, col_reg}<=6'b111110)) color_data = 12'b111111111110;

		end
		else if(card / 13 == 0)begin // Spades
			if(({row_reg, col_reg}==6'b000000)) color_data = 12'b111111111101;
			if(({row_reg, col_reg}==6'b000001)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b000010)) color_data = 12'b111111111111;
			if(({row_reg, col_reg}==6'b000011)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b000100)) color_data = 12'b111111101110;

			if(({row_reg, col_reg}>=6'b000101) && ({row_reg, col_reg}<6'b001001)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b001001)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b001010)) color_data = 12'b000100000010;
			if(({row_reg, col_reg}==6'b001011)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b001100)) color_data = 12'b001000000001;
			if(({row_reg, col_reg}==6'b001101)) color_data = 12'b111111101110;

			if(({row_reg, col_reg}==6'b001110)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b010000)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b010001)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b010010)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b010011)) color_data = 12'b000100000011;
			if(({row_reg, col_reg}==6'b010100)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b010101)) color_data = 12'b000100000001;

			if(({row_reg, col_reg}==6'b010110)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b011000)) color_data = 12'b001000000001;
			if(({row_reg, col_reg}==6'b011001)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b011010)) color_data = 12'b000100000011;
			if(({row_reg, col_reg}==6'b011011)) color_data = 12'b001000000100;
			if(({row_reg, col_reg}==6'b011100)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b011101)) color_data = 12'b001000010010;

			if(({row_reg, col_reg}==6'b011110)) color_data = 12'b000100000001;
			if(({row_reg, col_reg}==6'b100000)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b100001)) color_data = 12'b000100000010;
			if(({row_reg, col_reg}>=6'b100010) && ({row_reg, col_reg}<6'b100101)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b100101)) color_data = 12'b001000000010;

			if(({row_reg, col_reg}==6'b100110)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b101000)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b101001)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b101010)) color_data = 12'b001000000011;
			if(({row_reg, col_reg}==6'b101011)) color_data = 12'b000100000010;
			if(({row_reg, col_reg}==6'b101100)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b101101)) color_data = 12'b001000000001;

			if(({row_reg, col_reg}==6'b101110)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b110000)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}>=6'b110001) && ({row_reg, col_reg}<6'b110011)) color_data = 12'b111111101111;
			if(({row_reg, col_reg}==6'b110011)) color_data = 12'b001000000010;
			if(({row_reg, col_reg}==6'b110100)) color_data = 12'b111111101111;

			if(({row_reg, col_reg}>=6'b110101) && ({row_reg, col_reg}<6'b111000)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b111000)) color_data = 12'b111111111110;
			if(({row_reg, col_reg}==6'b111001)) color_data = 12'b111111101110;
			if(({row_reg, col_reg}==6'b111010)) color_data = 12'b001000010010;
			if(({row_reg, col_reg}==6'b111011)) color_data = 12'b000100000010;
			if(({row_reg, col_reg}==6'b111100)) color_data = 12'b001000010001;

			if(({row_reg, col_reg}>=6'b111101) && ({row_reg, col_reg}<=6'b111110)) color_data = 12'b111111111110;
		end	
		else if(card / 13 == 4) begin
			color_data  = 12'b0000_0000_0000;
		end

		
	end
endmodule