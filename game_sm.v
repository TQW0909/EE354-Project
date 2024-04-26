module UltimateTexasHoldem(
    input clk,
    input reset,
    input ack,
    input start,  // Start a new game
    input [5:0] anteBet,  // Ante bet size
    input [5:0] blindBet, // Blind bet size
    input check, // Check (up)
    input bet, // bet_ready & bet/ 2-bet /4-bet (left)
    input three_bet_fold, // 3 bet or fold (right)
	output [11:0] playerCardsFlat,  // Flattened player cards
    output [11:0] dealerCardsFlat,  // Flattened dealer cards
    output [29:0] communityCardsFlat,
    output [3:0] gameState,
    output reg gameActive,
	output reg [1:0] Final_result,
	output reg [8:0] out_win,
    output reg [5:0] out_loss
);

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

    // State register
    reg [3:0] state;

	
    reg [5:0] currentAnte, currentBlind, currentPlay;
    reg [8:0] win;
    reg [5:0] loss;
    reg playerFolded;
    reg playerBetted;

    reg [5:0] playerCards [0:1]; // Player's two cards
    reg [5:0] dealerCards [0:1]; // Dealer's two cards
    reg [5:0] communityCards [0:4]; // Five community cards
    wire[1:0] result; // 0 = dealer wins, 1 = player wins, 2 = tie
    wire [3:0] playerHand;
    wire qualify;
    reg compareHands;
	reg draw_card = 0;
	reg disp_con;
	wire [53:0] dealt_cards;
	wire all_cards_dealt;  
    wire done;
	
	assign playerCardsFlat = {playerCards[0], playerCards[1]};
    assign dealerCardsFlat = {dealerCards[0], dealerCards[1]};
    assign communityCardsFlat = {communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]};

    PokerHandEvaluation HandEvaluation(
        .clk(clk),
        .start(compareHands),
        .reset(reset),
        .playerCards({playerCards[0], playerCards[1]}),
        .dealerCards({dealerCards[0], dealerCards[1]}),
        .communityCards({communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]}),
        .result(result),
        .playerHand(playerHand),
        .qualify(qualify),
        .done(done)
    );
	
	card_game card_dealer(
		.clk(clk),
		.reset(reset),
		.draw_card(draw_card),  
		.dealt_cards(dealt_cards),
		.all_cards_dealt(all_cards_dealt)
	);
	
	
    // State transition logic   
    always @ (posedge clk, posedge reset) 
    begin
        if (reset) 
        begin
            state <= INIT;
			disp_con <= 0;
            draw_card <= 0;
            gameActive <= 0;
            currentAnte <= 0;
            currentBlind <= 0;
            currentPlay <= 0;
            playerFolded <= 0;
            playerBetted <= 0;
            win <= 0;
            loss <= 0;
			Final_result <= 0;
			out_win <= 0;
			out_loss <= 0;
        end 
        else
        begin
            case (state)
                INIT: 
                begin
					
                    if (start)begin
						gameActive <= 1;
                        state <= DEAL_CARDS;
						draw_card <= 1;
					end
					
					 // start dealing cards
                    currentAnte <= 5; //anteBet; // Set the initial bets from inputs
                    currentBlind <= 5; // blindBet;
                    currentPlay <= 0;
                    playerFolded <= 0;
                    playerBetted <= 0;
                    win <= 0;
                    loss <= 0;
					Final_result <= 0;
					out_win <= 0;
					out_loss <= 0;
                end

                DEAL_CARDS:
                begin
					
					//Deal the cards until all 9 are dealt_cards
					if(all_cards_dealt && !start) begin
						draw_card <= 0;
						state <= PROCESS_CARDS;
						disp_con <= 0;
					end

                end
				
				PROCESS_CARDS:
				begin
					// Assign player and dealer hand (2 cards) and 5 community card
					playerCards[0] <= {dealt_cards[5], dealt_cards[4], dealt_cards[3], dealt_cards[2], dealt_cards[1], dealt_cards[0]};
					playerCards[1] <= {dealt_cards[11], dealt_cards[10], dealt_cards[9], dealt_cards[8], dealt_cards[7], dealt_cards[6]};
					
					dealerCards[0] <= {dealt_cards[17], dealt_cards[16], dealt_cards[15], dealt_cards[14], dealt_cards[13], dealt_cards[12]};
					dealerCards[1] <= {dealt_cards[23], dealt_cards[22], dealt_cards[21], dealt_cards[20], dealt_cards[19], dealt_cards[18]};
					
					communityCards[0] <= {dealt_cards[29], dealt_cards[28], dealt_cards[27], dealt_cards[26], dealt_cards[25], dealt_cards[24]};
					communityCards[1] <= {dealt_cards[35], dealt_cards[34], dealt_cards[33], dealt_cards[32], dealt_cards[31], dealt_cards[30]};
					
					communityCards[2] <= {dealt_cards[41], dealt_cards[40], dealt_cards[39], dealt_cards[38], dealt_cards[37], dealt_cards[36]};
					
					communityCards[3] <= {dealt_cards[47], dealt_cards[46], dealt_cards[45], dealt_cards[44], dealt_cards[43], dealt_cards[42]};
					communityCards[4] <= {dealt_cards[53], dealt_cards[52], dealt_cards[51], dealt_cards[50], dealt_cards[49], dealt_cards[48]};
					
					if(start)begin
						state <= PRE_FLOP;
					end
					
					
                    // Show the player's hand
				end

                PRE_FLOP: 
                begin

                    if (bet) // 4-bet
                    begin
                        currentPlay <= anteBet * 4;
                        playerBetted <= 1;
                        state <= FLOP;
                    end
                    else if (three_bet_fold) // 3-bet
                    begin
                        currentPlay <= anteBet * 3;
                        playerBetted <= 1;
                        state <= FLOP;
                    end
                    else if (check)
                        state <= FLOP;
                end

                FLOP:
                begin
                    if (playerBetted && start)
                        state <= TURN_RIVER;
                    else if(start)
                        state <= POST_FLOP;

                    // Show first three cards of communityCards
                end

                POST_FLOP:
                begin
                    if (bet) // 2-bet
                    begin
                        currentPlay <= anteBet * 2;
                        playerBetted <= 1;
                        state <= TURN_RIVER;
                    end
                    else if (check)
                        state <= TURN_RIVER;
                end

                TURN_RIVER:
                begin
                    if (playerBetted && start)
                        state <= SHOWDOWN;
                    else if(start)
                        state <= FINAL_DECISION;

                    // Show last two cards of communityCards
                end

                FINAL_DECISION:
                begin
                    if (check) // 1-bet
                    begin
                        currentPlay <= anteBet;
                        playerBetted <= 1;
                        state <= SHOWDOWN;
                    end
                    else if (three_bet_fold) // Fold
					begin
                        playerFolded <= 1;
                        state <= SHOWDOWN;
					end
                end

                SHOWDOWN: 
                begin
					if(start && check && three_bet_fold)begin
						state <= RESULT;
						compareHands <= 1;
					end
                    // Display Dealers hand
                end

                RESULT:
                begin
                    compareHands <= 0;

                    if (done)
                    begin
						Final_result <= result;
                        if (result == 0) // Dealer wins
                        begin
                            if (qualify)
                                // Loose ante
                                loss = loss + currentAnte + currentBlind + currentPlay;
                            // Loose blind and play
							else
								loss = loss + currentBlind + currentPlay;

                        end
                        else if (result == 1) // Player wins
                        begin
                            
                            // Win play
                            // win = win + currentPlay;
                            
                            if (playerHand == 4) // Straight
							begin
                                // Win 1:1 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + currentBlind;
								else
									win = win + currentPlay + currentBlind;
							end
                            else if (playerHand == 5) // Flush
							begin
                                // Win 3:2 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + ((currentBlind * 3) / 2);
								else
									win = win + currentPlay + ((currentBlind * 3) / 2);
							end
                            else if (playerHand == 6) // Full House
							begin
                                // Win 3:1 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + currentBlind * 3;
								else
									win = win + currentPlay + currentBlind * 3;
							end
                            else if (playerHand == 7) // Four of a Kind
							begin
                                // Win 10:1 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + currentBlind * 10;
								else
									win = win + currentPlay + currentBlind * 10;
							end
                            else if (playerHand == 8) // Straight Flush
							begin
                                // Win 50:1 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + currentBlind * 50;
								else
									win = win + currentPlay + currentBlind * 50;
							end
                            else if (playerHand == 9) // Royal Flush
							begin
                                // Win 500:1 blind
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte + currentBlind * 500;
								else
									win = win + currentPlay + currentBlind * 500;
							end
							else
							begin
								if (qualify)
                                // Win ante
									win = win + currentPlay + currentAnte;
								else
									win = win + currentPlay;
							end
								
                        end
                        // else // Tie
                            // Push blind ante and play
                        state <= FINISH;
						
                    end
                end

                FINISH:
                begin
					out_win <= win;
					out_loss <= loss;
                    if (start && bet && check && three_bet_fold)	
                        state <= INIT;
                end

                default:		
                    state <= UNK;
            endcase
        end
    end

    // Output logic
	assign gameState = state;
	//assign out_win = win;
	//assign out_loss = loss;

endmodule
