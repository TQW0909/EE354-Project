`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	input [3:0] gameState,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	// wire block_fill;

	// State encoding
    localparam INIT               = 4'd0,
               DEAL_CARDS         = 4'd1,
			   PROCESS_CARDS      = 4'd2,
               PRE_FLOP           = 4'd3,
               FLOP               = 4'd4,
               POST_FLOP          = 4'd5,
               TURN_RIVER         = 4'd6,
               FINAL_DECISION     = 4'd7,
               SHOWDOWN           = 4'd8,
               RESULT             = 4'd9,
               FINISH             = 4'd10,
               UNK                = 4'dX;

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
		else if (gameState == PROCESS_CARDS)
		begin
			if (player1_fill) 
				rgb = 12'b1111_1111_1111; // White
			else if (player2_fill)
				rgb = 12'b1111_1111_1111;
		end
		else if (gameState == FLOP)
		begin
			if (community1_fill)
				rgb = 12'b1111_1111_1111;
			else if (community2_fill)
				rgb = 12'b1111_1111_1111;
			else if (community3_fill)
				rgb = 12'b1111_1111_1111;
		end
		else if (gameState == TURN_RIVER)
		begin
			if (community4_fill)
				rgb = 12'b1111_1111_1111;
			else if (community5_fill)
				rgb = 12'b1111_1111_1111;
		end
		else if (gameState == SHOWDOWN)
		begin
			if (dealer1_fill) 
				rgb = 12'b1111_1111_1111;
			else if (dealer2_fill)
				rgb = 12'b1111_1111_1111;
		end
		else	
			rgb=GREEN;
	end
		
	// //the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	// assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	

	
endmodule
