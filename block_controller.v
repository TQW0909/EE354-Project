`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input mstClk,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	input [3:0] gameState,
	input [5:0] playerCard_one,
	input [5:0] playerCard_two,
	input [5:0] dealerCard_one,
	input [5:0] dealerCard_two,
	input [5:0] comCard_one,
	input [5:0] comCard_two,
	input [5:0] comCard_three,
	input [5:0] comCard_four,
	input [5:0] comCard_five,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	
	
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
	//Player Card1
	reg [9:0] player_card_1_x, player_card_1_y;
	reg [9:0] player_card_1_suite_top_x, player_card_1_suite_top_y;
	reg [9:0] player_card_1_num_x, player_card_1_num_y;
	reg [9:0] player_card_1_suite_bot_x, player_card_1_suite_bot_y;
	wire [11:0] player_card_1_color;
	wire [11:0] player_card_1_suite_top_color;
	wire [11:0] player_card_1_num_color;
	wire [11:0] player_card_1_suite_bot_color;
	wire player_card_1_borders;
	wire player_card_1_suit_top_borders;
	wire player_card_1_num_borders;
	wire player_card_1_suit_bot_borders;
	
	assign player_card_1_borders=vCount>=(player_card_1_y) && vCount<=(player_card_1_y+51) && hCount>=(player_card_1_x) && hCount<=(player_card_1_x+36);
	assign player_card_1_suit_top_borders=vCount>=(player_card_1_suite_top_y) && vCount<=(player_card_1_suite_top_y+7) && hCount>=(player_card_1_suite_top_x) && hCount<=(player_card_1_suite_top_x+6);
	assign player_card_1_suit_bot_borders=vCount>=(player_card_1_suite_bot_y) && vCount<=(player_card_1_suite_bot_y+7) && hCount>=(player_card_1_suite_bot_x) && hCount<=(player_card_1_suite_bot_x+6);
	assign player_card_1_num_borders = vCount>=(player_card_1_num_y) && vCount<=(player_card_1_num_y+4) && hCount>=(player_card_1_num_x) && hCount<=(player_card_1_num_x+6);
	
	empty_rom dd(.clk(mstClk), .row(moveLeft ? vCount - player_card_1_y :vCount-player_card_1_y), .col(moveLeft ? 30 - hCount+player_card_1_x :hCount-player_card_1_x), .color_data(player_card_1_color));
	two_rom sb(.clk(mstClk), .row(vCount - player_card_1_num_y), .col(hCount - player_card_1_num_x), .card(playerCard_one), .color_data(player_card_1_num_color));
	suites_rom sd(.clk(mstClk), .row(vCount - player_card_1_suite_top_y), .col(hCount - player_card_1_suite_top_x), .card(playerCard_one), .color_data(player_card_1_suite_top_color));
	suites_rom sc(.clk(mstClk), .row(vCount - player_card_1_suite_bot_y), .col(hCount - player_card_1_suite_bot_x), .card(playerCard_one), .color_data(player_card_1_suite_bot_color));
	reg moveLeft;
	
	//Player Card 2
	reg [9:0] player_card_2_x, player_card_2_y;
	reg [9:0] player_card_2_suite_top_x, player_card_2_suite_top_y;
	reg [9:0] player_card_2_num_x, player_card_2_num_y;
	reg [9:0] player_card_2_suite_bot_x, player_card_2_suite_bot_y;
	wire [11:0] player_card_2_color;
	wire [11:0] player_card_2_suite_top_color;
	wire [11:0] player_card_2_num_color;
	wire [11:0] player_card_2_suite_bot_color;
	wire player_card_2_borders;
	wire player_card_2_suit_top_borders;
	wire player_card_2_num_borders;
	wire player_card_2_suit_bot_borders;
	
	assign player_card_2_borders=vCount>=(player_card_2_y) && vCount<=(player_card_2_y+51) && hCount>=(player_card_2_x) && hCount<=(player_card_2_x+36);
	assign player_card_2_suit_top_borders=vCount>=(player_card_2_suite_top_y) && vCount<=(player_card_2_suite_top_y+7) && hCount>=(player_card_2_suite_top_x) && hCount<=(player_card_2_suite_top_x+6);
	assign player_card_2_suit_bot_borders=vCount>=(player_card_2_suite_bot_y) && vCount<=(player_card_2_suite_bot_y+7) && hCount>=(player_card_2_suite_bot_x) && hCount<=(player_card_2_suite_bot_x+6);
	assign player_card_2_num_borders = vCount>=(player_card_2_num_y) && vCount<=(player_card_2_num_y+4) && hCount>=(player_card_2_num_x) && hCount<=(player_card_2_num_x+6);
	
	empty_rom aa(.clk(mstClk), .row(moveLeft ? vCount - player_card_2_y :vCount-player_card_2_y), .col(moveLeft ? 30 - hCount+player_card_2_x :hCount-player_card_2_x), .color_data(player_card_2_color));
	two_rom ab(.clk(mstClk), .row(vCount - player_card_2_num_y), .col(hCount - player_card_2_num_x), .card(playerCard_two), .color_data(player_card_2_num_color));
	suites_rom ac(.clk(mstClk), .row(vCount - player_card_2_suite_top_y), .col(hCount - player_card_2_suite_top_x), .card(playerCard_two), .color_data(player_card_2_suite_top_color));
	suites_rom ad(.clk(mstClk), .row(vCount - player_card_2_suite_bot_y), .col(hCount - player_card_2_suite_bot_x), .card(playerCard_two), .color_data(player_card_2_suite_bot_color));
	
    //Dealer Card 1
	reg [9:0] dealer_card_1_x, dealer_card_1_y;
	reg [9:0] dealer_card_1_suite_top_x, dealer_card_1_suite_top_y;
	reg [9:0] dealer_card_1_num_x, dealer_card_1_num_y;
	reg [9:0] dealer_card_1_suite_bot_x, dealer_card_1_suite_bot_y;
	wire [11:0] dealer_card_1_color;
	wire [11:0] dealer_card_1_suite_top_color;
	wire [11:0] dealer_card_1_num_color;
	wire [11:0] dealer_card_1_suite_bot_color;
	wire dealer_card_1_borders;
	wire dealer_card_1_suit_top_borders;
	wire dealer_card_1_num_borders;
	wire dealer_card_1_suit_bot_borders;
	
	assign dealer_card_1_borders=vCount>=(dealer_card_1_y) && vCount<=(dealer_card_1_y+51) && hCount>=(dealer_card_1_x) && hCount<=(dealer_card_1_x+36);
	assign dealer_card_1_suit_top_borders=vCount>=(dealer_card_1_suite_top_y) && vCount<=(dealer_card_1_suite_top_y+7) && hCount>=(dealer_card_1_suite_top_x) && hCount<=(dealer_card_1_suite_top_x+6);
	assign dealer_card_1_suit_bot_borders=vCount>=(dealer_card_1_suite_bot_y) && vCount<=(dealer_card_1_suite_bot_y+7) && hCount>=(dealer_card_1_suite_bot_x) && hCount<=(dealer_card_1_suite_bot_x+6);
	assign dealer_card_1_num_borders = vCount>=(dealer_card_1_num_y) && vCount<=(dealer_card_1_num_y+4) && hCount>=(dealer_card_1_num_x) && hCount<=(dealer_card_1_num_x+6);
	
	empty_rom ae(.clk(mstClk), .row(moveLeft ? vCount - dealer_card_1_y :vCount-dealer_card_1_y), .col(moveLeft ? 30 - hCount+dealer_card_1_x :hCount-dealer_card_1_x), .color_data(dealer_card_1_color));
	two_rom af(.clk(mstClk), .row(vCount - dealer_card_1_num_y), .col(hCount - dealer_card_1_num_x), .card(dealerCard_one), .color_data(dealer_card_1_num_color));
	suites_rom al(.clk(mstClk), .row(vCount - dealer_card_1_suite_top_y), .col(hCount - dealer_card_1_suite_top_x), .card(dealerCard_one), .color_data(dealer_card_1_suite_top_color));
	suites_rom ak(.clk(mstClk), .row(vCount - dealer_card_1_suite_bot_y), .col(hCount - dealer_card_1_suite_bot_x), .card(dealerCard_one), .color_data(dealer_card_1_suite_bot_color));
	
	//Dealer Card 2
	reg [9:0] dealer_card_2_x, dealer_card_2_y;
	reg [9:0] dealer_card_2_suite_top_x, dealer_card_2_suite_top_y;
	reg [9:0] dealer_card_2_num_x, dealer_card_2_num_y;
	reg [9:0] dealer_card_2_suite_bot_x, dealer_card_2_suite_bot_y;
	wire [11:0] dealer_card_2_color;
	wire [11:0] dealer_card_2_suite_top_color;
	wire [11:0] dealer_card_2_num_color;
	wire [11:0] dealer_card_2_suite_bot_color;
	wire dealer_card_2_borders;
	wire dealer_card_2_suit_top_borders;
	wire dealer_card_2_num_borders;
	wire dealer_card_2_suit_bot_borders;
	
	assign dealer_card_2_borders=vCount>=(dealer_card_2_y) && vCount<=(dealer_card_2_y+51) && hCount>=(dealer_card_2_x) && hCount<=(dealer_card_2_x+36);
	assign dealer_card_2_suit_top_borders=vCount>=(dealer_card_2_suite_top_y) && vCount<=(dealer_card_2_suite_top_y+7) && hCount>=(dealer_card_2_suite_top_x) && hCount<=(dealer_card_2_suite_top_x+6);
	assign dealer_card_2_suit_bot_borders=vCount>=(dealer_card_2_suite_bot_y) && vCount<=(dealer_card_2_suite_bot_y+7) && hCount>=(dealer_card_2_suite_bot_x) && hCount<=(dealer_card_2_suite_bot_x+6);
	assign dealer_card_2_num_borders = vCount>=(dealer_card_2_num_y) && vCount<=(dealer_card_2_num_y+4) && hCount>=(dealer_card_2_num_x) && hCount<=(dealer_card_2_num_x+6);
	
	empty_rom ba(.clk(mstClk), .row(moveLeft ? vCount - dealer_card_2_y :vCount-dealer_card_2_y), .col(moveLeft ? 30 - hCount+dealer_card_2_x :hCount-dealer_card_2_x), .color_data(dealer_card_2_color));
	two_rom bb(.clk(mstClk), .row(vCount - dealer_card_2_num_y), .col(hCount - dealer_card_2_num_x), .card(dealerCard_two), .color_data(dealer_card_2_num_color));
	suites_rom bc(.clk(mstClk), .row(vCount - dealer_card_2_suite_top_y), .col(hCount - dealer_card_2_suite_top_x), .card(dealerCard_two), .color_data(dealer_card_2_suite_top_color));
	suites_rom bd(.clk(mstClk), .row(vCount - dealer_card_2_suite_bot_y), .col(hCount - dealer_card_2_suite_bot_x), .card(dealerCard_two), .color_data(dealer_card_2_suite_bot_color));
	
	//Community Card 1
	reg [9:0] com_card_1_x, com_card_1_y;
	reg [9:0] com_card_1_suite_top_x, com_card_1_suite_top_y;
	reg [9:0] com_card_1_num_x, com_card_1_num_y;
	reg [9:0] com_card_1_suite_bot_x, com_card_1_suite_bot_y;
	wire [11:0] com_card_1_color;
	wire [11:0] com_card_1_suite_top_color;
	wire [11:0] com_card_1_num_color;
	wire [11:0] com_card_1_suite_bot_color;
	wire com_card_1_borders;
	wire com_card_1_suit_top_borders;
	wire com_card_1_num_borders;
	wire com_card_1_suit_bot_borders;
	
	assign com_card_1_borders=vCount>=(com_card_1_y) && vCount<=(com_card_1_y+51) && hCount>=(com_card_1_x) && hCount<=(com_card_1_x+36);
	assign com_card_1_suit_top_borders=vCount>=(com_card_1_suite_top_y) && vCount<=(com_card_1_suite_top_y+7) && hCount>=(com_card_1_suite_top_x) && hCount<=(com_card_1_suite_top_x+6);
	assign com_card_1_suit_bot_borders=vCount>=(com_card_1_suite_bot_y) && vCount<=(com_card_1_suite_bot_y+7) && hCount>=(com_card_1_suite_bot_x) && hCount<=(com_card_1_suite_bot_x+6);
	assign com_card_1_num_borders = vCount>=(com_card_1_num_y) && vCount<=(com_card_1_num_y+4) && hCount>=(com_card_1_num_x) && hCount<=(com_card_1_num_x+6);
	
	empty_rom ca(.clk(mstClk), .row(moveLeft ? vCount - com_card_1_y :vCount-com_card_1_y), .col(moveLeft ? 30 - hCount+com_card_1_x :hCount-com_card_1_x), .color_data(com_card_1_color));
	two_rom cb(.clk(mstClk), .row(vCount - com_card_1_num_y), .col(hCount - com_card_1_num_x), .card(comCard_one), .color_data(com_card_1_num_color));
	suites_rom cc(.clk(mstClk), .row(vCount - com_card_1_suite_top_y), .col(hCount - com_card_1_suite_top_x), .card(comCard_one), .color_data(com_card_1_suite_top_color));
	suites_rom cd(.clk(mstClk), .row(vCount - com_card_1_suite_bot_y), .col(hCount - com_card_1_suite_bot_x), .card(comCard_one), .color_data(com_card_1_suite_bot_color));
	reg [5:0] card_counter;
	
	//Community Card 2
	reg [9:0] com_card_2_x, com_card_2_y;
	reg [9:0] com_card_2_suite_top_x, com_card_2_suite_top_y;
	reg [9:0] com_card_2_num_x, com_card_2_num_y;
	reg [9:0] com_card_2_suite_bot_x, com_card_2_suite_bot_y;
	wire [11:0] com_card_2_color;
	wire [11:0] com_card_2_suite_top_color;
	wire [11:0] com_card_2_num_color;
	wire [11:0] com_card_2_suite_bot_color;
	wire com_card_2_borders;
	wire com_card_2_suit_top_borders;
	wire com_card_2_num_borders;
	wire com_card_2_suit_bot_borders;
	
	assign com_card_2_borders=vCount>=(com_card_2_y) && vCount<=(com_card_2_y+51) && hCount>=(com_card_2_x) && hCount<=(com_card_2_x+36);
	assign com_card_2_suit_top_borders=vCount>=(com_card_2_suite_top_y) && vCount<=(com_card_2_suite_top_y+7) && hCount>=(com_card_2_suite_top_x) && hCount<=(com_card_2_suite_top_x+6);
	assign com_card_2_suit_bot_borders=vCount>=(com_card_2_suite_bot_y) && vCount<=(com_card_2_suite_bot_y+7) && hCount>=(com_card_2_suite_bot_x) && hCount<=(com_card_2_suite_bot_x+6);
	assign com_card_2_num_borders = vCount>=(com_card_2_num_y) && vCount<=(com_card_2_num_y+4) && hCount>=(com_card_2_num_x) && hCount<=(com_card_2_num_x+6);
	
	empty_rom da(.clk(mstClk), .row(moveLeft ? vCount - com_card_2_y :vCount-com_card_2_y), .col(moveLeft ? 30 - hCount+com_card_2_x :hCount-com_card_2_x), .color_data(com_card_2_color));
	two_rom db(.clk(mstClk), .row(vCount - com_card_2_num_y), .col(hCount - com_card_2_num_x), .card(comCard_two), .color_data(com_card_2_num_color));
	suites_rom dc(.clk(mstClk), .row(vCount - com_card_2_suite_top_y), .col(hCount - com_card_2_suite_top_x), .card(comCard_two), .color_data(com_card_2_suite_top_color));
	suites_rom de(.clk(mstClk), .row(vCount - com_card_2_suite_bot_y), .col(hCount - com_card_2_suite_bot_x), .card(comCard_two), .color_data(com_card_2_suite_bot_color));
	
	//Community Card 3
	reg [9:0] com_card_3_x, com_card_3_y;
	reg [9:0] com_card_3_suite_top_x, com_card_3_suite_top_y;
	reg [9:0] com_card_3_num_x, com_card_3_num_y;
	reg [9:0] com_card_3_suite_bot_x, com_card_3_suite_bot_y;
	wire [11:0] com_card_3_color;
	wire [11:0] com_card_3_suite_top_color;
	wire [11:0] com_card_3_num_color;
	wire [11:0] com_card_3_suite_bot_color;
	wire com_card_3_borders;
	wire com_card_3_suit_top_borders;
	wire com_card_3_num_borders;
	wire com_card_3_suit_bot_borders;
	
	assign com_card_3_borders=vCount>=(com_card_3_y) && vCount<=(com_card_3_y+51) && hCount>=(com_card_3_x) && hCount<=(com_card_3_x+36);
	assign com_card_3_suit_top_borders=vCount>=(com_card_3_suite_top_y) && vCount<=(com_card_3_suite_top_y+7) && hCount>=(com_card_3_suite_top_x) && hCount<=(com_card_3_suite_top_x+6);
	assign com_card_3_suit_bot_borders=vCount>=(com_card_3_suite_bot_y) && vCount<=(com_card_3_suite_bot_y+7) && hCount>=(com_card_3_suite_bot_x) && hCount<=(com_card_3_suite_bot_x+6);
	assign com_card_3_num_borders = vCount>=(com_card_3_num_y) && vCount<=(com_card_3_num_y+4) && hCount>=(com_card_3_num_x) && hCount<=(com_card_3_num_x+6);
	
	empty_rom ea(.clk(mstClk), .row(moveLeft ? vCount - com_card_3_y :vCount-com_card_3_y), .col(moveLeft ? 30 - hCount+com_card_3_x :hCount-com_card_3_x), .color_data(com_card_3_color));
	two_rom eb(.clk(mstClk), .row(vCount - com_card_3_num_y), .col(hCount - com_card_3_num_x), .card(comCard_three), .color_data(com_card_3_num_color));
	suites_rom ec(.clk(mstClk), .row(vCount - com_card_3_suite_top_y), .col(hCount - com_card_3_suite_top_x), .card(comCard_three), .color_data(com_card_3_suite_top_color));
	suites_rom ee(.clk(mstClk), .row(vCount - com_card_3_suite_bot_y), .col(hCount - com_card_3_suite_bot_x), .card(comCard_three), .color_data(com_card_3_suite_bot_color));
	
	//Community Card 4
	reg [9:0] com_card_4_x, com_card_4_y;
	reg [9:0] com_card_4_suite_top_x, com_card_4_suite_top_y;
	reg [9:0] com_card_4_num_x, com_card_4_num_y;
	reg [9:0] com_card_4_suite_bot_x, com_card_4_suite_bot_y;
	wire [11:0] com_card_4_color;
	wire [11:0] com_card_4_suite_top_color;
	wire [11:0] com_card_4_num_color;
	wire [11:0] com_card_4_suite_bot_color;
	wire com_card_4_borders;
	wire com_card_4_suit_top_borders;
	wire com_card_4_num_borders;
	wire com_card_4_suit_bot_borders;
	
	assign com_card_4_borders=vCount>=(com_card_4_y) && vCount<=(com_card_4_y+51) && hCount>=(com_card_4_x) && hCount<=(com_card_4_x+36);
	assign com_card_4_suit_top_borders=vCount>=(com_card_4_suite_top_y) && vCount<=(com_card_4_suite_top_y+7) && hCount>=(com_card_4_suite_top_x) && hCount<=(com_card_4_suite_top_x+6);
	assign com_card_4_suit_bot_borders=vCount>=(com_card_4_suite_bot_y) && vCount<=(com_card_4_suite_bot_y+7) && hCount>=(com_card_4_suite_bot_x) && hCount<=(com_card_4_suite_bot_x+6);
	assign com_card_4_num_borders = vCount>=(com_card_4_num_y) && vCount<=(com_card_4_num_y+4) && hCount>=(com_card_4_num_x) && hCount<=(com_card_4_num_x+6);
	
	empty_rom fa(.clk(mstClk), .row(moveLeft ? vCount - com_card_4_y :vCount-com_card_4_y), .col(moveLeft ? 30 - hCount+com_card_4_x :hCount-com_card_4_x), .color_data(com_card_4_color));
	two_rom fb(.clk(mstClk), .row(vCount - com_card_4_num_y), .col(hCount - com_card_4_num_x), .card(comCard_four), .color_data(com_card_4_num_color));
	suites_rom fc(.clk(mstClk), .row(vCount - com_card_4_suite_top_y), .col(hCount - com_card_4_suite_top_x), .card(comCard_four), .color_data(com_card_4_suite_top_color));
	suites_rom fe(.clk(mstClk), .row(vCount - com_card_4_suite_bot_y), .col(hCount - com_card_4_suite_bot_x), .card(comCard_four), .color_data(com_card_4_suite_bot_color));

	//Community Card 5
	reg [9:0] com_card_5_x, com_card_5_y;
	reg [9:0] com_card_5_suite_top_x, com_card_5_suite_top_y;
	reg [9:0] com_card_5_num_x, com_card_5_num_y;
	reg [9:0] com_card_5_suite_bot_x, com_card_5_suite_bot_y;
	wire [11:0] com_card_5_color;
	wire [11:0] com_card_5_suite_top_color;
	wire [11:0] com_card_5_num_color;
	wire [11:0] com_card_5_suite_bot_color;
	wire com_card_5_borders;
	wire com_card_5_suit_top_borders;
	wire com_card_5_num_borders;
	wire com_card_5_suit_bot_borders;
	
	assign com_card_5_borders=vCount>=(com_card_5_y) && vCount<=(com_card_5_y+51) && hCount>=(com_card_5_x) && hCount<=(com_card_5_x+36);
	assign com_card_5_suit_top_borders=vCount>=(com_card_5_suite_top_y) && vCount<=(com_card_5_suite_top_y+7) && hCount>=(com_card_5_suite_top_x) && hCount<=(com_card_5_suite_top_x+6);
	assign com_card_5_suit_bot_borders=vCount>=(com_card_5_suite_bot_y) && vCount<=(com_card_5_suite_bot_y+7) && hCount>=(com_card_5_suite_bot_x) && hCount<=(com_card_5_suite_bot_x+6);
	assign com_card_5_num_borders = vCount>=(com_card_5_num_y) && vCount<=(com_card_5_num_y+4) && hCount>=(com_card_5_num_x) && hCount<=(com_card_5_num_x+6);
	
	empty_rom can(.clk(mstClk), .row(moveLeft ? vCount - com_card_5_y :vCount-com_card_5_y), .col(moveLeft ? 30 - hCount+com_card_5_x :hCount-com_card_5_x), .color_data(com_card_5_color));
	two_rom kamil(.clk(mstClk), .row(vCount - com_card_5_num_y), .col(hCount - com_card_5_num_x), .card(comCard_five), .color_data(com_card_5_num_color));
	suites_rom banu(.clk(mstClk), .row(vCount - com_card_5_suite_top_y), .col(hCount - com_card_5_suite_top_x), .card(comCard_five), .color_data(com_card_5_suite_top_color));
	suites_rom kaan(.clk(mstClk), .row(vCount - com_card_5_suite_bot_y), .col(hCount - com_card_5_suite_bot_x), .card(comCard_five), .color_data(com_card_5_suite_bot_color));
	
	
	
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if(gameState == PROCESS_CARDS || gameState == PRE_FLOP)begin
			if (player_card_1_borders) begin
				if (player_card_1_num_borders) begin
					rgb = player_card_1_num_color;
				end
				else if(player_card_1_suit_top_borders)begin
					rgb = player_card_1_suite_top_color;
				end
				else if(player_card_1_suit_bot_borders)begin
					rgb = player_card_1_suite_bot_color;
				end
				else
					rgb = player_card_1_color;
			end
			else if (player_card_2_borders) begin
				if (player_card_2_num_borders) begin
					rgb = player_card_2_num_color;
				end
				else if(player_card_2_suit_top_borders)begin
					rgb = player_card_2_suite_top_color;
				end
				else if(player_card_2_suit_bot_borders)begin
					rgb = player_card_2_suite_bot_color;
				end
				else
					rgb = player_card_2_color;
			end
			else if (dealer_card_1_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if(dealer_card_2_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_1_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_2_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_3_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_4_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_5_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else 
				rgb = background;
			
		end
		else if (gameState == FLOP || gameState == POST_FLOP)begin
			if (player_card_1_borders) begin
				if (player_card_1_num_borders) begin
					rgb = player_card_1_num_color;
				end
				else if(player_card_1_suit_top_borders)begin
					rgb = player_card_1_suite_top_color;
				end
				else if(player_card_1_suit_bot_borders)begin
					rgb = player_card_1_suite_bot_color;
				end
				else
					rgb = player_card_1_color;
				end
			else if (player_card_2_borders) begin
				if (player_card_2_num_borders) begin
					rgb = player_card_2_num_color;
				end
				else if(player_card_2_suit_top_borders)begin
					rgb = player_card_2_suite_top_color;
				end
				else if(player_card_2_suit_bot_borders)begin
					rgb = player_card_2_suite_bot_color;
				end
				else
					rgb = player_card_2_color;
			end
			else if (com_card_1_borders) begin
				if (com_card_1_num_borders) begin
					rgb = com_card_1_num_color;
				end
				else if(com_card_1_suit_top_borders)begin
					rgb = com_card_1_suite_top_color;
				end
				else if(com_card_1_suit_bot_borders)begin
					rgb = com_card_1_suite_bot_color;
				end
				else
					rgb = com_card_1_color;
			end
			else if (com_card_2_borders) begin
				if (com_card_2_num_borders) begin
					rgb = com_card_2_num_color;
				end
				else if(com_card_2_suit_top_borders)begin
					rgb = com_card_2_suite_top_color;
				end
				else if(com_card_2_suit_bot_borders)begin
					rgb = com_card_2_suite_bot_color;
				end
				else
					rgb = com_card_2_color;
			end
			else if (com_card_3_borders) begin
				if (com_card_3_num_borders) begin
					rgb = com_card_3_num_color;
				end
				else if(com_card_3_suit_top_borders)begin
					rgb = com_card_3_suite_top_color;
				end
				else if(com_card_3_suit_bot_borders)begin
					rgb = com_card_3_suite_bot_color;
				end
				else
					rgb = com_card_3_color;
			end
			else if (dealer_card_1_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if(dealer_card_2_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_4_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if (com_card_5_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else 
				rgb = background;
			
			
		end
		else if (gameState == TURN_RIVER || gameState == FINAL_DECISION)begin
			if (player_card_1_borders) begin
				if (player_card_1_num_borders) begin
					rgb = player_card_1_num_color;
				end
				else if(player_card_1_suit_top_borders)begin
					rgb = player_card_1_suite_top_color;
				end
				else if(player_card_1_suit_bot_borders)begin
					rgb = player_card_1_suite_bot_color;
				end
				else
					rgb = player_card_1_color;
				end
			else if (player_card_2_borders) begin
				if (player_card_2_num_borders) begin
					rgb = player_card_2_num_color;
				end
				else if(player_card_2_suit_top_borders)begin
					rgb = player_card_2_suite_top_color;
				end
				else if(player_card_2_suit_bot_borders)begin
					rgb = player_card_2_suite_bot_color;
				end
				else
					rgb = player_card_2_color;
			end
			else if (com_card_1_borders) begin
				if (com_card_1_num_borders) begin
					rgb = com_card_1_num_color;
				end
				else if(com_card_1_suit_top_borders)begin
					rgb = com_card_1_suite_top_color;
				end
				else if(com_card_1_suit_bot_borders)begin
					rgb = com_card_1_suite_bot_color;
				end
				else
					rgb = com_card_1_color;
			end
			else if (com_card_2_borders) begin
				if (com_card_2_num_borders) begin
					rgb = com_card_2_num_color;
				end
				else if(com_card_2_suit_top_borders)begin
					rgb = com_card_2_suite_top_color;
				end
				else if(com_card_2_suit_bot_borders)begin
					rgb = com_card_2_suite_bot_color;
				end
				else
					rgb = com_card_2_color;
			end
			else if (com_card_3_borders) begin
				if (com_card_3_num_borders) begin
					rgb = com_card_3_num_color;
				end
				else if(com_card_3_suit_top_borders)begin
					rgb = com_card_3_suite_top_color;
				end
				else if(com_card_3_suit_bot_borders)begin
					rgb = com_card_3_suite_bot_color;
				end
				else
					rgb = com_card_3_color;
			end
			else if (com_card_4_borders) begin
				if (com_card_4_num_borders) begin
					rgb = com_card_4_num_color;
				end
				else if(com_card_4_suit_top_borders)begin
					rgb = com_card_4_suite_top_color;
				end
				else if(com_card_4_suit_bot_borders)begin
					rgb = com_card_4_suite_bot_color;
				end
				else
					rgb = com_card_4_color;
			end
			else if (com_card_5_borders) begin
				if (com_card_5_num_borders) begin
					rgb = com_card_5_num_color;
				end
				else if(com_card_5_suit_top_borders)begin
					rgb = com_card_5_suite_top_color;
				end
				else if(com_card_5_suit_bot_borders)begin
					rgb = com_card_5_suite_bot_color;
				end
				else
					rgb = com_card_5_color;
			end
			else if (dealer_card_1_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else if(dealer_card_2_borders)begin
				rgb = 12'b0000_0000_0000;
			end
			else 
				rgb = background;
		end
		
		else if (gameState == SHOWDOWN || gameState == RESULT || gameState == FINISH)begin
			if (player_card_1_borders) begin
				if (player_card_1_num_borders) begin
					rgb = player_card_1_num_color;
				end
				else if(player_card_1_suit_top_borders)begin
					rgb = player_card_1_suite_top_color;
				end
				else if(player_card_1_suit_bot_borders)begin
					rgb = player_card_1_suite_bot_color;
				end
				else
					rgb = player_card_1_color;
				end
			else if (player_card_2_borders) begin
				if (player_card_2_num_borders) begin
					rgb = player_card_2_num_color;
				end
				else if(player_card_2_suit_top_borders)begin
					rgb = player_card_2_suite_top_color;
				end
				else if(player_card_2_suit_bot_borders)begin
					rgb = player_card_2_suite_bot_color;
				end
				else
					rgb = player_card_2_color;
			end
			else if (com_card_1_borders) begin
				if (com_card_1_num_borders) begin
					rgb = com_card_1_num_color;
				end
				else if(com_card_1_suit_top_borders)begin
					rgb = com_card_1_suite_top_color;
				end
				else if(com_card_1_suit_bot_borders)begin
					rgb = com_card_1_suite_bot_color;
				end
				else
					rgb = com_card_1_color;
			end
			else if (com_card_2_borders) begin
				if (com_card_2_num_borders) begin
					rgb = com_card_2_num_color;
				end
				else if(com_card_2_suit_top_borders)begin
					rgb = com_card_2_suite_top_color;
				end
				else if(com_card_2_suit_bot_borders)begin
					rgb = com_card_2_suite_bot_color;
				end
				else
					rgb = com_card_2_color;
			end
			else if (com_card_3_borders) begin
				if (com_card_3_num_borders) begin
					rgb = com_card_3_num_color;
				end
				else if(com_card_3_suit_top_borders)begin
					rgb = com_card_3_suite_top_color;
				end
				else if(com_card_3_suit_bot_borders)begin
					rgb = com_card_3_suite_bot_color;
				end
				else
					rgb = com_card_3_color;
			end
			else if (com_card_4_borders) begin
				if (com_card_4_num_borders) begin
					rgb = com_card_4_num_color;
				end
				else if(com_card_4_suit_top_borders)begin
					rgb = com_card_4_suite_top_color;
				end
				else if(com_card_4_suit_bot_borders)begin
					rgb = com_card_4_suite_bot_color;
				end
				else
					rgb = com_card_4_color;
			end
			else if (com_card_5_borders) begin
				if (com_card_5_num_borders) begin
					rgb = com_card_5_num_color;
				end
				else if(com_card_5_suit_top_borders)begin
					rgb = com_card_5_suite_top_color;
				end
				else if(com_card_5_suit_bot_borders)begin
					rgb = com_card_5_suite_bot_color;
				end
				else
					rgb = com_card_5_color;
			end
			else if (dealer_card_1_borders) begin
				if (dealer_card_1_num_borders) begin
					rgb = dealer_card_1_num_color;
				end
				else if(dealer_card_1_suit_top_borders)begin
					rgb = dealer_card_1_suite_top_color;
				end
				else if(dealer_card_1_suit_bot_borders)begin
					rgb = dealer_card_1_suite_bot_color;
				end
				else
					rgb = dealer_card_1_color;
			end
			else if (dealer_card_2_borders) begin
				if (dealer_card_2_num_borders) begin
					rgb = dealer_card_2_num_color;
				end
				else if(dealer_card_2_suit_top_borders)begin
					rgb = dealer_card_2_suite_top_color;
				end
				else if(dealer_card_2_suit_bot_borders)begin
					rgb = dealer_card_2_suite_bot_color;
				end
				else
					rgb = dealer_card_2_color;
			end
			else 
				rgb = background;
		end
		else
			rgb=background;
	end
	
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			card_counter <= 0;
			
			com_card_1_x <= 440;
			com_card_1_y <= 150;
			
			com_card_2_x <= 480;
			com_card_2_y <= 150;
			
			com_card_3_x <= 520;
			com_card_3_y <= 150;
			
			com_card_4_x <= 400;
			com_card_4_y <= 150;
			
			com_card_5_x <= 560;
			com_card_5_y <= 150;
			
			dealer_card_1_x <= 150;
			dealer_card_1_y <= 150;
			
			dealer_card_2_x <= 190;
			dealer_card_2_y <= 150;
			
			player_card_1_x <= 480;
			player_card_1_y <= 280;
			
			player_card_2_x <= 440;
			player_card_2_y <= 280;
			
		end
		else if (clk) begin
		
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/	
			//p1
			player_card_1_suite_top_x <= player_card_1_x;
			player_card_1_suite_top_y <= player_card_1_y;
			
			player_card_1_suite_bot_x <= player_card_1_x + 30;
			player_card_1_suite_bot_y <= player_card_1_y + 44;
			
			player_card_1_num_x <= player_card_1_x + 14;
			player_card_1_num_y <= player_card_1_y + 21;
			
			//P2
			player_card_2_suite_top_x <= player_card_2_x;
			player_card_2_suite_top_y <= player_card_2_y;
			
			player_card_2_suite_bot_x <= player_card_2_x + 30;
			player_card_2_suite_bot_y <= player_card_2_y + 44;
			
			player_card_2_num_x <= player_card_2_x + 14;
			player_card_2_num_y <= player_card_2_y + 21;
			
			//D1
			dealer_card_1_suite_top_x <= dealer_card_1_x;
			dealer_card_1_suite_top_y <= dealer_card_1_y;
			
			dealer_card_1_suite_bot_x <= dealer_card_1_x + 30;
			dealer_card_1_suite_bot_y <= dealer_card_1_y + 44;
			
			dealer_card_1_num_x <= dealer_card_1_x + 14;
			dealer_card_1_num_y <= dealer_card_1_y + 21;
			
			//D2
			dealer_card_2_suite_top_x <= dealer_card_2_x;
			dealer_card_2_suite_top_y <= dealer_card_2_y;
			
			dealer_card_2_suite_bot_x <= dealer_card_2_x + 30;
			dealer_card_2_suite_bot_y <= dealer_card_2_y + 44;
			
			dealer_card_2_num_x <= dealer_card_2_x + 14;
			dealer_card_2_num_y <= dealer_card_2_y + 21;
			
			//C1
			com_card_1_suite_top_x <= com_card_1_x;
			com_card_1_suite_top_y <= com_card_1_y;
			
			com_card_1_suite_bot_x <= com_card_1_x + 30;
			com_card_1_suite_bot_y <= com_card_1_y + 44;
			
			com_card_1_num_x <= com_card_1_x + 14;
			com_card_1_num_y <= com_card_1_y + 21;
			
			//C2
			com_card_2_suite_top_x <= com_card_2_x;
			com_card_2_suite_top_y <= com_card_2_y;
			
			com_card_2_suite_bot_x <= com_card_2_x + 30;
			com_card_2_suite_bot_y <= com_card_2_y + 44;
			
			com_card_2_num_x <= com_card_2_x + 14;
			com_card_2_num_y <= com_card_2_y + 21;
			
			//C3
			com_card_3_suite_top_x <= com_card_3_x;
			com_card_3_suite_top_y <= com_card_3_y;
			
			com_card_3_suite_bot_x <= com_card_3_x + 30;
			com_card_3_suite_bot_y <= com_card_3_y + 44;
			
			com_card_3_num_x <= com_card_3_x + 14;
			com_card_3_num_y <= com_card_3_y + 21;
			
			//C4
			com_card_4_suite_top_x <= com_card_4_x;
			com_card_4_suite_top_y <= com_card_4_y;
			
			com_card_4_suite_bot_x <= com_card_4_x + 30;
			com_card_4_suite_bot_y <= com_card_4_y + 44;
			
			com_card_4_num_x <= com_card_4_x + 14;
			com_card_4_num_y <= com_card_4_y + 21;
			
			//C5
			com_card_5_suite_top_x <= com_card_5_x;
			com_card_5_suite_top_y <= com_card_5_y;
			
			com_card_5_suite_bot_x <= com_card_5_x + 30;
			com_card_5_suite_bot_y <= com_card_5_y + 44;
			
			com_card_5_num_x <= com_card_5_x + 14;
			com_card_5_num_y <= com_card_5_y + 21;
			
			
			
		end
	end
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			background <= 12'b0000_1111_0000;
	end
	
	

	
	
endmodule
