// 
// Card number: 0 - 51 (52 cards total)
// Suit: card number \ 13 (0 for Spades, 1 for Hearts, 2 for Diamonds, 3 for Clubs)
// Rank: card number % 13 (0-8 for 2-10, 9 for Jack, 10 for Queen, 11 for King, 12 for Ace)
// 
module PokerHandEvaluation(
    input clk,
    input start,
    input reset,
    input [11:0] playerCards, // Flattened from [5:0] playerCards [0:1]
    input [11:0] dealerCards, // Flattened from [5:0] dealerCards [0:1]
    input [29:0] communityCards, // Flattened from [5:0] communityCards [0:4]
    output reg [1:0] result,
    output reg [3:0] playerHand,
    output reg qualify,
	output reg done
);

// Redeclare internally as arrays
reg [5:0] playerCardsArray [0:1];
reg [5:0] dealerCardsArray [0:1];
reg [5:0] communityCardsArray [0:4];


// Array to hold the full hand (7 cards)
reg [5:0] fullPlayerHand [0:6];
reg [5:0] fullDealerHand [0:6];

reg [15:0] playerHandScore, dealerHandScore;
reg [5:0] playerKicker1, playerKicker2, playerKicker3, playerKicker4, playerKicker5;
reg [5:0] dealerKicker1, dealerKicker2, dealerKicker3, dealerKicker4, dealerKicker5;
reg [3:0] playerHandType;
reg [3:0] dealerHand;
reg [5:0] playerKickers[0:4];
reg [5:0] dealerKickers[0:4];

integer k;
integer break;

// Functions to evaluate hands
task evaluateHand;
	input [5:0] card0, card1, card2, card3, card4, card5, card6;
	output reg [15:0] handScore;
    output reg [5:0] kicker1, kicker2, kicker3, kicker4, kicker5;
    integer i;
	reg [5:0] cards [0:6];
    reg [3:0] ranks[0:12];  // Each rank count can range from 0 to 13, requiring 4 bits
	reg [2:0] suits[0:3];   // Each suit count can range from 0 to 13, requiring 4 bits (3 bits if strictly 0-12)
    integer maxRankCount, secondMaxRankCount, flush, flushSuit, flushHigh, straight, topStraight, maxStraightLength, currentLength, straightHigh;
    integer maxRank, secondMaxRank;
    integer kicker [0:5]; // Array to hold the top 5 kickers
	integer kickerIdx;
	integer evaluateHand;

    begin
	
		$display("Starting hand evaluation at %t", $time);
		
        // Initialize
        maxRankCount = 0;
        secondMaxRankCount = 0;
        flush = 0;
        flushSuit = 63; // 63 will be used to indicate invalid
        flushHigh = 63;
        straight = 0;
        topStraight = 0;
        maxStraightLength = 0;
        currentLength = 0;
        straightHigh = 0;
        maxRank = 63;
        secondMaxRank = 63;
		kickerIdx = 0;
		
		for (i = 0; i <= 12; i = i + 1) 
		begin
			ranks[i] = 0;
		end
		for (i = 0; i <= 3; i = i + 1) 
		begin
			suits[i] = 0;
		end
		
		
		
		cards[0] = card0; cards[1] = card1; cards[2] = card2;
        cards[3] = card3; cards[4] = card4; cards[5] = card5; cards[6] = card6;
		
		$display("cards[0]: %d, cards[1]: %d, cards[2]: %d", cards[0], cards[1], cards[2]);
        $display("cards[3]: %d, cards[4]: %d, cards[5]: %d, cards[6]: %d", cards[3], cards[4], cards[5], cards[6]);


        // Count occurrences of each rank and suit
        for (i = 0; i <= 6; i = i + 1) 
        begin
            ranks[cards[i] % 13] = ranks[cards[i] % 13] + 1;
            suits[cards[i] / 13] = suits[cards[i] / 13] + 1;
        end
		
		// After all calculations are done
		$display("Final Ranks and Suits:");
		for (i = 0; i < 13; i = i + 1) begin
			$display("ranks[%d] = %d", i, ranks[i]);
		end
		for (i = 0; i < 4; i = i + 1) begin
			$display("suits[%d] = %d", i, suits[i]);
		end
		
		

        // Determine max rank and second max rank count
        for (i = 0; i < 13; i = i + 1) 
        begin
            if (ranks[i] > maxRankCount) 
            begin
                secondMaxRankCount = maxRankCount; // Update second max to previous max
                secondMaxRank = maxRank;
                maxRankCount = ranks[i]; // Update max to the new highest count
                maxRank = i;
            end 
            else if (ranks[i] > secondMaxRankCount) 
            begin
                secondMaxRankCount = ranks[i]; // Update second max if current rank count is higher but less than max
                secondMaxRank = i;   
            end
        end

        // Check for flush
        for (i = 0; i < 4; i = i + 1) 
        begin
            if (suits[i] >= 5)
            begin
                flush = 1;
                flushSuit = i;
            end
        end

        if (flush)
        begin 
			for (i = 0; i <= 6; i = i + 1) 
			begin
				if (cards[i] / 13 == flushSuit)
				begin
					if ((flushHigh == 63) || ((cards[i] % 13) > flushHigh))
						flushHigh = cards[i] % 13;
				end
			end
        end

        // Check for straight
        if (ranks[9] && ranks[10] && ranks[11] && ranks[12] && ranks[0]) // 10, J, Q, K, A
        begin
            maxStraightLength = 5;
            topStraight = 1;
        end
        else
        begin
            for (i = 0; i < 13; i = i + 1) 
            begin
                if (ranks[i] > 0)
                    currentLength = currentLength + 1;
                else 
                    currentLength = 0;

                if (currentLength > maxStraightLength) 
				begin
                    maxStraightLength = currentLength;
                    straightHigh = i;
				end
            end
        end

        if (maxStraightLength >= 5) 
            straight = 1;

        
        for (i = 0; i < 5; i = i + 1) 
            kicker[i] = 63; // Initialize kickers

        // Identify Kickers (top 5 cards that are not part of the main component)
        for (i = 12; i >= 0 && kickerIdx < 5; i = i - 1) 
        begin
            if (i != maxRank && i != secondMaxRank && ranks[i] > 0) 
            begin
                kicker[kickerIdx] = i;
                kickerIdx = kickerIdx + 1;
            end
        end


        // Scoring hands: Simplified to numeric values
        if (topStraight && flush) 
            evaluateHand = 9000; // Royal Flush
        else if (straight && flush) 
            evaluateHand = 8000 + straightHigh; // Straight Flush
        else if (maxRankCount == 4) 
            evaluateHand = 7000 + (maxRank + 1) * 20 + kicker[0]; // Four of a Kind (plus kicker)
        else if (maxRankCount == 3 && secondMaxRankCount == 2) 
            evaluateHand = 6000 + (maxRank + 1) * 20 + secondMaxRank; // Full House
        else if (flush) 
            evaluateHand = 5000 + flushHigh; // Flush
        else if (straight) 
            evaluateHand = 4000 + straightHigh; // Straight
        else if (maxRankCount == 3) 
            evaluateHand = 3000 + maxRank; // Three of a Kind
        else if (maxRankCount == 2 && secondMaxRankCount == 2)
        begin
            if (maxRank > secondMaxRank)
                evaluateHand = 2000 + (maxRank + 1) * 20 + secondMaxRank; // Two Pair
            else
                evaluateHand = 2000 + (secondMaxRank + 1) * 20 + maxRank; // Two Pair
        end 
        else if (maxRankCount == 2) 
            evaluateHand = 1000 + maxRank; // One PairhandScore
        else 
            evaluateHand = kicker[0]; // High Card
			
		handScore = evaluateHand;

        // evaluateHand = {evaluateHand, kicker[0], kicker[1], kicker[2], kicker[3], kicker[4]};
		kicker1 = kicker[0];
        kicker2 = kicker[1];
        kicker3 = kicker[2];
        kicker4 = kicker[3];
        kicker5 = kicker[4];
		
		$display("Hand score: %d computed at %t", handScore, $time);
    end
endtask

// Combine and evaluate hands
always @(posedge clk) 
begin
    if (reset)
	begin
        result <= 2'bx;
        playerHand <= 4'bx;
        qualify <= 1'bx;
		done <= 0;
	end
    else if (start)
    begin
		done = 0;
		
		playerCardsArray[0] = playerCards[11:6];
        playerCardsArray[1] = playerCards[5:0];
        dealerCardsArray[0] = dealerCards[11:6];
        dealerCardsArray[1] = dealerCards[5:0];
        communityCardsArray[0] = communityCards[29:24];
        communityCardsArray[1] = communityCards[23:18];
        communityCardsArray[2] = communityCards[17:12];
        communityCardsArray[3] = communityCards[11:6];
        communityCardsArray[4] = communityCards[5:0];
		
		
		evaluateHand(playerCardsArray[0], playerCardsArray[1], communityCardsArray[0], 
             communityCardsArray[1],communityCardsArray[2],communityCardsArray[3], communityCardsArray[4],
             playerHandScore, playerKicker1, playerKicker2, playerKicker3, playerKicker4, playerKicker5);
			 
		evaluateHand(dealerCardsArray[0], dealerCardsArray[1], communityCardsArray[0],
             communityCardsArray[1],communityCardsArray[2],communityCardsArray[3], communityCardsArray[4],
             dealerHandScore, dealerKicker1, dealerKicker2, dealerKicker3, dealerKicker4, dealerKicker5);

        playerHandType = playerHandScore / 1000;
        playerHand = playerHandType;

        dealerHand = dealerHandScore / 1000;

        if (dealerHand >= 2)
            qualify = 1;
		else
			qualify = 0;


        // Determine the winner using hand score and then kickers in case of a tie
        if (playerHandScore > dealerHandScore)
            result = 1; // Player wins
        else if (playerHandScore < dealerHandScore)
            result = 0; // Dealer wins
        else 
        begin
            
            if (playerHandType <= 3)
            begin
				playerKickers[0] = playerKicker1;
				playerKickers[1] = playerKicker2;
				playerKickers[2] = playerKicker3;
				playerKickers[3] = playerKicker4;
				playerKickers[4] = playerKicker5;

				dealerKickers[0] = dealerKicker1;
				dealerKickers[1] = dealerKicker2;
				dealerKickers[2] = dealerKicker3;
				dealerKickers[3] = dealerKicker4;
				dealerKickers[4] = dealerKicker5;

                k = 0;
                break = 0;

                while ((k < 5) && (!break)) 
                begin
                    if ((playerKickers[k] != 63) && (dealerKickers[k] != 63)) 
                    begin
                        if (playerKickers[k] > dealerKickers[k]) 
                        begin
                            result = 1;
                            break = 1;
                        end 
                        else if (playerKickers[k] < dealerKickers[k]) 
                        begin
                            result = 0;
                            break = 1;
                        end
                    end
                    k = k + 1;

                    if ((playerHandType == 2) && (k == 1)) // If two pair hand
                    begin
                        result = 2;
                        break = 1;
                    end
                    else if ((playerHandType == 3) && (k == 2)) // If trips hand
                    begin
                        result = 2;
                        break = 1;
                    end
                    else if ((playerHandType == 1) && (k == 3)) // If one pair hand
                    begin
                        result = 2;
                        break = 1;
                    end
                end
                if (k == 5) // If all the same for high card hand
                    result = 2;
            end
            else
                result = 2;
        end
		done = 1; 
    end
end

endmodule
