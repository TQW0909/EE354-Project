// 
// Card number: 0 - 51 (52 cards total)
// Suit: card number \ 13 (0 for Spades, 1 for Hearts, 2 for Diamonds, 3 for Clubs)
// Rank: card number % 13 (0-8 for 2-10, 9 for Jack, 10 for Queen, 11 for King, 12 for Ace)
// 
module PokerHandEvaluation(
    input clk,
    input start,
    input reset,
    input [5:0] playerCards [0:1], // Player's two cards
    input [5:0] dealerCards [0:1], // Dealer's two cards
    input [5:0] communityCards [0:4], // Five community cards
    output reg [1:0] result // 0 = dealer wins, 1 = player wins, 2 = tie
    output reg [3:0] playerHand // 1 - 9
    output reg qualify
);

// Array to hold the full hand (7 cards)
reg [5:0] fullPlayerHand [0:6];
reg [5:0] fullDealerHand [0:6];

reg [15:0] playerHandScore, dealerHandScore;
reg [5:0] playerKicker1, playerKicker2, playerKicker3, playerKicker4, playerKicker5;
reg [5:0] dealerKicker1, dealerKicker2, dealerKicker3, dealerKicker4, dealerKicker5;
reg [3:0]playerHandType;

// Functions to evaluate hands
function integer evaluateHand(input [5:0] cards [0:6]);
    integer i;
    reg [12:0] ranks;
    reg [3:0] suits;
    reg [4:0] rankCount [0:12];
    integer maxRankCount, secondMaxRankCount, flush, flushSuit, flushHigh, straight, topStraight, maxStraightLength, currentLength, straightHigh;
    integer maxRank, secondMaxRank;
    integer kicker [0:5]; // Array to hold the top 5 kickers

    begin
        // Initialize
        ranks = 0;
        suits = 0;
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


        // Count occurrences of each rank and suit
        for (i = 0; i <= 6; i++) 
        begin
            ranks[cards[i] % 13] += 1;
            suits[cards[i] / 13] += 1;
        end

        // Determine max rank and second max rank count
        for (i = 0; i < 13; i++) 
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
        for (i = 0; i < 4; i++) 
        begin
            if (suits[i] >= 5)
            begin
                flush = 1;
                flushSuit = i;
            end
        end

        if (flush)
        begin 
            for (i = 12; i >= 0 && flushHigh == 63; i--) 
            begin
                if ((ranks[i] > 0) && suits[i] == flushSuit) 
                begin
                    flushHigh = i;
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
            for (i = 0; i < 13; i++) 
            begin
                if (rankCount[i] > 0)
                    currentLength += 1;
                else 
                    currentLength = 0;

                if (currentLength > maxStraightLength) 
                    maxStraightLength = currentLength;
                    straightHigh = i;
            end
        end

        if (maxStraightLength >= 5) 
            straight = 1;

        
        for (i = 0; i < 5; i++) 
            kicker[i] = 63; // Initialize kickers

        // Identify Kickers (top 5 cards that are not part of the main component)
        integer kickerIdx = 0;
        for (i = 12; i >= 0 && kickerIdx < 5; i--) 
        begin
            if (i != maxRank && i != secondMaxRank && ranks[i] > 0) 
            begin
                kicker[kickerIdx] = i;
                kickerIdx++;
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
            evaluateHand = 1000 + maxRank; // One Pair
        else 
            evaluateHand = kicker[0]; // High Card

        evaluateHand = {evaluateHand, kicker[0], kicker[1], kicker[2], kicker[3], kicker[4]}
    end
endfunction

// Combine and evaluate hands
always @(posedge clk) 
begin
    if (reset)
        result <= 2'bx;
        playerHand <= 4'bx;
    else if (!start)
        result <= result;
        playerHand <= playerHand;
    else 
    begin
        // Combine cards into full hands
        fullPlayerHand = {playerCards[0], playerCards[1], communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]};
        fullDealerHand = {dealerCards[0], dealerCards[1], communityCards[0], communityCards[1], communityCards[2], communityCards[3], communityCards[4]};

        // Evaluate each hand
        {playerHandScore, playerKicker1, playerKicker2, playerKicker3, playerKicker4, playerKicker5} = evaluateHand(fullPlayerHand);
        {dealerHandScore, dealerKicker1, dealerKicker2, dealerKicker3, dealerKicker4, dealerKicker5} = evaluateHand(fullDealerHand);

        playerHandType = playerHandScore / 1000;
        playerHand = playerHandType;

        dealerHand = dealerHandScore / 1000;

        if (dealerHand >= 2)
            qualify = 1;


        // Determine the winner using hand score and then kickers in case of a tie
        if (playerHandScore > dealerHandScore)
            result = 1; // Player wins
        else if (playerHandScore < dealerHandScore)
            result = 0; // Dealer wins
        else 
        begin
            
            if (playerHandType <= 3)
            begin
                reg [5:0] playerKickers[0:4] = {playerKicker1, playerKicker2, playerKicker3, playerKicker4, playerKicker5};
                reg [5:0] dealerKickers[0:4] = {dealerKicker1, dealerKicker2, dealerKicker3, dealerKicker4, dealerKicker5};

                integer k = 0;
                integer break = 0;

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

                    if ((playerHandType == 2) && (k = 1)) // If two pair hand
                    begin
                        result = 2;
                        break = 1;
                    end
                    else if ((playerHandType == 3) && (k = 2)) // If trips hand
                    begin
                        result = 2;
                        break = 1;
                    end
                    else if ((playerHandType == 1) && (k = 3)) // If one pair hand
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
    end
end

endmodule
