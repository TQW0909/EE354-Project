`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	input Sw0,
	input Sw1, 
	input Sw2, 
	input Sw3, 
	input Sw4, 
	input Sw5, 
	input Sw6, 
	input Sw7,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	//output MemOE, MemWR, RamCS,
	output  QuadSpiFlashCS
	);
	wire Reset;
	assign Reset=BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire rst;

	wire [7:0] Xin;

	// For game SM
	wire ACK;
	wire start_game;
	wire [5:0] ante_blind_size;
	wire [1:0] playerDecision;
	wire [3:0] gameState;
	wire gameActive;
	wire move_clk;
	wire [11:0] playerCardsFlatt;
    wire [11:0] dealerCardsFlatt;
    wire [29:0] communityCardsFlatt;
	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	wire [3:0] SSD4, SSD5, SSD6, SSD7;
	reg [7:0]  	SSD_CATHODES;
	wire [2:0] 	ssdscan_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	assign Xin   =  {Sw7,  Sw6,  Sw5,  Sw4,  Sw3,  Sw2,  Sw1, Sw0};
	wire [11:0] background;
	
	wire buttonU, buttonL, buttonR, buttonD, buttonC;
	
	wire [1:0] Final_result;
	wire [8:0] win;
    wire [5:0] loss;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	
	ee201_debouncer #(.N_dc(25)) ee201_debouncer_1 
        (.CLK(ClkPort), .RESET(Reset), .PB(BtnL), .DPB( ), .SCEN(buttonL), .MCEN( ), .CCEN( ));
	
	ee201_debouncer #(.N_dc(25)) ee201_debouncer_2 
        (.CLK(ClkPort), .RESET(Reset), .PB(BtnU), .DPB( ), .SCEN(buttonU), .MCEN( ), .CCEN( ));
	
	ee201_debouncer #(.N_dc(25)) ee201_debouncer_3 
        (.CLK(ClkPort), .RESET(Reset), .PB(BtnD), .DPB( ), .SCEN(buttonD), .MCEN( ), .CCEN( ));
	
	ee201_debouncer #(.N_dc(25)) ee201_debouncer_4 
        (.CLK(ClkPort), .RESET(Reset), .PB(BtnC), .DPB( ), .SCEN(buttonC), .MCEN( ), .CCEN( ));
	
	ee201_debouncer #(.N_dc(25)) ee201_debouncer_5 
        (.CLK(ClkPort), .RESET(Reset), .PB(BtnR), .DPB( ), .SCEN(buttonR), .MCEN( ), .CCEN( ));
	
	UltimateTexasHoldem uth(
   	.clk(ClkPort),
    .reset(BtnC),
    .ack(ACK),
    .start(Sw0),  // Start a new game
    .anteBet(ante_blind_size),  // Ante bet size
    .blindBet(ante_blind_size), // Blind bet size
	.check(Sw1),
	.bet(Sw2),
	.three_bet_fold(Sw3), 
	.playerCardsFlat(playerCardsFlatt), 
	.dealerCardsFlat(dealerCardsFlatt), 
	.communityCardsFlat(communityCardsFlatt),
    .gameState(gameState),
    .gameActive(gameActive),
	.Final_result(Final_result),
	.out_win(win),
	.out_loss(loss)
	);
	
	
	
	
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	//block_controller sc(.clk(move_clk), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD),.left(BtnL),.right(BtnR),.hCount(hc), .vCount(vc), .gameState(gameState), .playerCard_one(playerCardsFlatt[11:6]), .playerCard_two(playerCardsFlatt[5:0]), 
	//.dealerCard_one(dealerCardsFlatt[11:6]), .dealerCard_two(dealerCardsFlatt[5:0]), .comCard_one(communityCardsFlat[29:24]), .comCard_two(communityCardsFlatt[23:18]), .comCard_three(communityCardsFlatt[17:12]), .comCard_four(communityCardsFlatt[11:6]), .comCard_five(communityCardsFlat[5:0]) .rgb(rgb), .background(background));
	block_controller sc(
    .clk(move_clk), 
    .bright(bright),
	.mstClk(ClkPort),
    .rst(BtnC), 
    .up(BtnU), 
    .down(BtnD),
    .left(BtnL),
    .right(BtnR),
    .hCount(hc), 
    .vCount(vc), 
    .gameState(gameState), 
    .playerCard_one(playerCardsFlatt[11:6]), 
    .playerCard_two(playerCardsFlatt[5:0]), 
    .dealerCard_one(dealerCardsFlatt[11:6]), 
    .dealerCard_two(dealerCardsFlatt[5:0]), 
    .comCard_one(communityCardsFlatt[29:24]), 
    .comCard_two(communityCardsFlatt[23:18]), 
    .comCard_three(communityCardsFlatt[17:12]), 
    .comCard_four(communityCardsFlatt[11:6]), 
    .comCard_five(communityCardsFlatt[5:0]),  
    .rgb(rgb), 
    .background(background)
);  

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	// disable mamory ports
	//assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	assign QuadSpiFlashCS = 1'b1;
	
	//------------
// SSD (Seven Segment Display)
	// reg [3:0]	SSD;
	// wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	
	//SSDs display 
	//to show how we can interface our "game" module with the SSD's, we output the 12-bit rgb background value to the SSD's
	assign SSD3 = loss[5:4];
	assign SSD2 = loss[3:0];
	assign SSD6 = win[8];
	assign SSD5 = win[7:4];
	assign SSD4 = win[3:0];
	// assign SSD1 = background[7:4];
	assign SSD0 = Final_result;
	
	assign SSD7 = gameState;

	// need a scan clk for the seven segment display 
	
	// 100 MHz / 2^18 = 381.5 cycles/sec ==> frequency of DIV_CLK[17]
	// 100 MHz / 2^19 = 190.7 cycles/sec ==> frequency of DIV_CLK[18]
	// 100 MHz / 2^20 =  95.4 cycles/sec ==> frequency of DIV_CLK[19]
	
	// 381.5 cycles/sec (2.62 ms per digit) [which means all 4 digits are lit once every 10.5 ms (reciprocal of 95.4 cycles/sec)] works well.
	
	//                  --|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |   
    //                    |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 
	//  DIV_CLK[17]       |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
	//
	//               -----|     |-----|     |-----|     |-----|     |
    //                    |  0  |  1  |  0  |  1  |     |     |     |     
	//  DIV_CLK[18]       |_____|     |_____|     |_____|     |_____|
	//
	//         -----------|           |-----------|           |
    //                    |  0     0  |  1     1  |           |           
	//  DIV_CLK[19]       |___________|           |___________|
	//

	assign ssdscan_clk = DIV_CLK[20:18];
	assign An0	= !(~(ssdscan_clk[2]) && ~(ssdscan_clk[1]) &&  ~(ssdscan_clk[0])); // when ssdscan_clk = 000
	assign An1	= !(~(ssdscan_clk[2]) &&~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 001
	assign An2	=  !(~(ssdscan_clk[2]) && (ssdscan_clk[1]) &&  ~(ssdscan_clk[0]));  // when ssdscan_clk = 010
	assign An3	=  !(~(ssdscan_clk[2]) && (ssdscan_clk[1]) &&  (ssdscan_clk[0])); // when ssdscan_clk = 011
	
	assign An4	= !((ssdscan_clk[2]) && ~(ssdscan_clk[1]) &&  ~(ssdscan_clk[0]));  // when ssdscan_clk = 100
	assign An5	= !((ssdscan_clk[2]) && ~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 101
	assign An6	=  !((ssdscan_clk[2]) && (ssdscan_clk[1]) &&  ~(ssdscan_clk[0]));  // when ssdscan_clk = 110
	assign An7	=  !((ssdscan_clk[2]) && (ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 111
	// Turn off another 4 anodes
	//assign {An7, An6, An5, An4} = 4'b1111;
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3, SSD4, SSD5, SSD6, SSD7)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  3'b000: SSD = SSD0;
				  3'b001: SSD = SSD1;
				  3'b010: SSD = SSD2;
				  3'b011: SSD = SSD3;
				  3'b100: SSD = SSD4;
				  3'b101: SSD = SSD5;
				  3'b110: SSD = SSD6;
				  3'b111: SSD = SSD7;
		endcase 
	end
	
	
	
	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000010; // 0
			4'b0001: SSD_CATHODES = 8'b10011110; // 1
			4'b0010: SSD_CATHODES = 8'b00100100; // 2
			4'b0011: SSD_CATHODES = 8'b00001100; // 3
			4'b0100: SSD_CATHODES = 8'b10011000; // 4
			4'b0101: SSD_CATHODES = 8'b01001000; // 5
			4'b0110: SSD_CATHODES = 8'b01000000; // 6
			4'b0111: SSD_CATHODES = 8'b00011110; // 7
			4'b1000: SSD_CATHODES = 8'b00000000; // 8
			4'b1001: SSD_CATHODES = 8'b00001000; // 9
			4'b1010: SSD_CATHODES = 8'b00010000; // A
			4'b1011: SSD_CATHODES = 8'b11000000; // B
			4'b1100: SSD_CATHODES = 8'b01100010; // C
			4'b1101: SSD_CATHODES = 8'b10000100; // D
			4'b1110: SSD_CATHODES = 8'b01100000; // E
			4'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

endmodule
