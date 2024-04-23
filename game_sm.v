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
    output reg [3:0] gameState,
    output reg gameActive
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
    reg [8:0] won;
    reg [5:0] lost;
    reg playerFolded;
    reg playerBetted;

    reg [5:0] playerCards [0:1]; // Player's two cards
    reg [5:0] dealerCards [0:1]; // Dealer's two cards
    reg [5:0] communityCards [0:4]; // Five community cards
    reg [1:0] result; // 0 = dealer wins, 1 = player wins, 2 = tie
    reg [3:0] playerHand;
    reg qualify;
    reg compareHands;
	reg draw_card = 0;
	
	wire [53:0] dealt_cards;
	wire all_cards_dealt;  
    wire done;

    HandEvaluation PokerHandEvaluation(
        .clk(clk),
        .start(compareHands),
        .reset(reset),
        .playerCards({playerCards[0], playerCards[1]}),
        .dealerCards({dealerCards[0], dealerCards[1]}),
        .communityCards({communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]}),
        .result(result),
        .playerHand(playerHand),
        .qualify(qualify).
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

            draw_card <= 0;
            gameActive <= 0;
            currentAnte <= 0;
            currentBlind <= 0;
            currentPlay <= 0;
            playerFolded <= 0;
            playerBetted <= 0;
            won <= 0;
            loss <= 0;
        end 
        else if (start)
        begin
            case (state)
                INIT: 
                begin
                    if (bet)
                        gameActive <= 1;
                        state <= DEAL;

					draw_card <= 1; // start dealing cards
                    currentAnte <= anteBet; // Set the initial bets from inputs
                    currentBlind <= blindBet;
                    currentPlay <= 0;
                    playerFolded <= 0;
                    playerBetted <= 0;
                    won <= 0;
                    loss <= 0;
                end

                DEAL_CARDS:
                begin
					//Deal the cards until all 9 are dealt_cards
					if(all_cards_dealt) begin
						draw_card <= 0;
						state <= PROCESS_CARDS;
					end
                    

                end
				
				PROCESS_CARDS:
				begin
					// Assign player and dealer hand (2 cards) and 5 community card
					playerCards[0] <= {dealt_cards[0], dealt_cards[1], dealt_cards[2], dealt_cards[3], dealt_cards[4], dealt_cards[5]};
					playerCards[1] <= {dealt_cards[6], dealt_cards[7], dealt_cards[8], dealt_cards[9], dealt_cards[10], dealt_cards[11]};
					
					dealerCards[0] <= {dealt_cards[12], dealt_cards[13], dealt_cards[14], dealt_cards[15], dealt_cards[16], dealt_cards[17]};
					dealerCards[1] <= {dealt_cards[18], dealt_cards[19], dealt_cards[20], dealt_cards[21], dealt_cards[22], dealt_cards[23]};
					
					communityCards[0] <= {dealt_cards[24], dealt_cards[25], dealt_cards[26], dealt_cards[27], dealt_cards[28], dealt_cards[29]};
					communityCards[1] <= {dealt_cards[30], dealt_cards[31], dealt_cards[32], dealt_cards[33], dealt_cards[34], dealt_cards[35]};
					
					communityCards[2] <= {dealt_cards[36], dealt_cards[37], dealt_cards[38], dealt_cards[39], dealt_cards[40], dealt_cards[41]};
					
					communityCards[3] <= {dealt_cards[42], dealt_cards[43], dealt_cards[44], dealt_cards[45], dealt_cards[46], dealt_cards[47]};
					communityCards[4] <= {dealt_cards[48], dealt_cards[49], dealt_cards[50], dealt_cards[51], dealt_cards[52], dealt_cards[53]};
					
					state <= PRE_FLOP;
					
                    // Show the player's hand
				end

                PRE_FLOP: 
                begin

                    if (bet) // 4-bet
                    begin
                        currentPlay <= anteBet * 4;
                        playerBetted = 1;
                        state <= FLOP;
                    end
                    else if (three_bet_fold) // 3-bet
                    begin
                        currentPlay <= anteBet * 3;
                        playerBetted = 1;
                        state <= FLOP;
                    end
                    else if (check)
                        state <= FLOP;
                end

                FLOP:
                begin
                    if (playerBetted)
                        state <= TURN_RIVER;
                    else
                        state <= POST_FLOP;

                    // Show first three cards of communityCards
                end

                POST_FLOP:
                begin
                    if (bet) // 2-bet
                    begin
                        currentPlay <= anteBet * 2;
                        playerBetted = 1;
                        state <= TURN_RIVER;
                    end
                    else if (check)
                        state <= TURN_RIVER;
                end

                TURN_RIVER:
                begin
                    if (playerBetted)
                        state <= SHOWDOWN;
                    else
                        state <= FINAL_DECISION;

                    // Show last two cards of communityCards
                end

                FINAL_DECISION:
                begin
                    if (check) // 1-bet
                    begin
                        currentPlay <= anteBet;
                        playerBetted = 1;
                        state <= SHOWDOWN;
                    end
                    else if (three_bet_fold) // Fold
                        playerFolded = 1;
                        state <= SHOWDOWN;
                end

                SHOWDOWN: 
                begin
                    state <= RESULT;
                    compareHands <= 1;

                    // Display Dealers hand
                end

                RESULT:
                begin
                    compareHands <= 0;

                    if (done)
                    begin

                        if (result == 0) // Dealer wins
                        begin
                            if (qualify)
                                // Loose ante
                                loss = loss + currentAnte;
                            // Loose blind and play
                            loss = loss + currentBlind;
                            loss = loss + currentPlay;

                        end
                        else if (result == 1) // Player wins
                        begin
                            if (qualify)
                                // Win ante
                                win = win + currentAnte;
                            // Win play
                            win = win + currentPlay;
                            
                            if (playerHand == 4) // Straight
                                // Win 1:1 blind
                                win = win + currentBlind;
                            else if (playerHand == 5) // Flush
                                // Win 3:2 blind
                                win = win + ((currentBlind * 3) / 2);
                            else if (playerHand == 6) // Full House
                                // Win 3:1 blind
                                win = win + currentBlind * 3;
                            else if (playerHand == 7) // Four of a Kind
                                // Win 10:1 blind
                                win = win + currentBlind * 10;
                            else if (playerHand == 8) // Straight Flush
                                // Win 50:1 blind
                                win = win + currentBlind * 50;
                            else if (playerHand == 9) // Royal Flush
                                // Win 500:1 blind
                                win = win + currentBlind * 500;
                        end
                        // else // Tie
                            // Push blind ante and play
                        state <= FINISH;
                    end
                end

                FINISH:
                begin
                    if (ack)	
                        state <= INIT;
                end

                default:		
                    state <= UNK;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        gameState = state;
        gameActive = (state != INIT && state != FINISH);
    end

endmodule
