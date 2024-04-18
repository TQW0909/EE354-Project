`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	// wire block_fill;

	wire player_fill;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;

	parameter CARD_X = 75;
	parameter CARD_Y = 75;

	// Position of cards (FIXED)
	parameter PLAYER1_X = 225;
	parameter PLAYER1_Y = 624;

	parameter PLAYER2_X = 325;
	parameter PLAYER2_Y = 624;
	
	parameter GREEN   = 12'b0000_1111_0000;

	assign player1_fill = vcount >= PLAYER1_X && vcount <= (PLAYER1_X + CARD_X) && hCount >= PLAYER1_Y && hCount <= (PLAYER1_Y + CARD_Y);
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright)	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (player1_fill) 
			rgb = 12'b1111_1111_1111;
		else	
			rgb=GREEN;
	end
		
	// //the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	// assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	

	
endmodule
