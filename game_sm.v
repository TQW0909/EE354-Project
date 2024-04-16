module UltimateTexasHoldem(
    input clk,
    input reset,
    input ack,
    input start,  // Start a new game
    input [5:0] anteBet,  // Ante bet size
    input [5:0] blindBet, // Blind bet size
    input [1:0] playerDecision, // Player decisions: 0 = check, 1 = bet/ 2-bet / 4-bet, 2 = 3-bet, 3 = fold
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
               FINISH             = 4'd10;
               UNK                = 4'dX;

    // State register
    reg [3:0] state;


    reg [5:0] currentAnte, currentBlind, currentPlay;
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
	
	wire [5:0] dealt_cards[8:0];
	wire all_cards_dealt;  
    HandEvaluation PokerHandEvaluation(
        .clk(clk),
        .start(compareHands),
        .reset(reset),
        .playerCards(playerCards),
        .dealerCards(dealerCards),
        .communityCards(communityCards),
        .result(result),
        .playerHand(playerHand),
        .qualify(qualify)
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

            gameActive <= 0;
            currentAnte <= 0;
            currentBlind <= 0;
            currentPlay <= 0;
            playerFolded <= 0;
            playerBetted <= 0;
        end 
        else 
        begin
            case (state)
                INIT: 
                begin
                    state <= DEAL;
					draw_card <= 1; // start dealing cards
                    currentAnte <= anteBet; // Set the initial bets from inputs
                    currentBlind <= blindBet;
                end

                DEAL_CARDS:
                begin
					//Deal the cards until all 9 are dealt_cards
					if(all_cards_dealt) begin
						draw_card <= 0;
						state <= PROCESS_CARDS;
					end
                    // Show the player's hand

                end
				
				PROCESS_CARDS:
				begin
					// Assign player and dealer hand (2 cards) and 5 community card
					{playerCards[0], playerCards[1]} <= {dealt_cards[0], dealt_cards[1]};
					{dealerCards[0], dealerCards[1]} <= {dealt_cards[2], dealt_cards[3]};
					
					{communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]} <= 
						{dealt_cards[4], dealt_cards[5], dealt_cards[6], dealt_cards[7], dealt_cards[8]};
					
					state <= PRE_FLOP;
					
				end

                PRE_FLOP: 
                begin
                    state <= FLOP;

                    if (playerDecision == 1) // 4-bet
                    begin
                        currentPlay <= anteBet * 4;
                        playerBetted = 1;
                    end
                    else if (playerDecision == 2) // 3-bet
                    begin
                        currentPlay <= anteBet * 3;
                        playerBetted = 1;
                    end
                end

                FLOP:
                begin
                    state <= POST_FLOP;

                    // Show first three cards of communityCards
                end

                POST_FLOP:
                begin
                    state <= TURN_RIVER;

                    if (!playerBetted)
                    begin
                        if (playerDecision == 1) // 2-bet
                        begin
                            currentPlay <= anteBet * 2;
                            playerBetted = 1;
                        end
                    end
                end

                TURN_RIVER:
                begin
                    state <= FINAL_DECISION;

                    // Show last two cards of communityCards
                end

                FINAL_DECISION:
                begin
                    state <= SHOWDOWN;

                    if (!playerBetted)
                    begin
                        if (playerDecision == 1) // 1-bet
                        begin
                            currentPlay <= anteBet;
                            playerBetted = 1;
                        end
                        else if (playerDecision == 3) // Fold
                            playerFolded = 1;
                    end
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

                    if (result == 0) // Dealer wins
                    begin
                        if (qualify)
                            // Loose ante
                        
                        // Loose blind and play

                    end
                    else if (result == 1) // Player wins
                    begin
                        if (qualify)
                            // Win ante
                        
                        // Win play
                        
                        if (playerHand == 4) // Straight
                            // Win 1:1 blind
                        else if (playerHand == 5) // Flush
                            // Win 3:2 blind
                        else if (playerHand == 6) // Full House
                            // Win 3:1 blind
                        else if (playerHand == 7) // Four of a Kind
                            // Win 10:1 blind
                        else if (playerHand == 8) // Straight Flush
                            // Win 50:1 blind
                        else if (playerHand == 9) // Royal Flush
                            // Win 500:1 blind
                    end

                    else // Tie
                        // Push blind ante and play

                    state <= FINISH;
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
