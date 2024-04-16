`timescale 1ns / 1ps

module PokerHandEvaluation_tb;

reg clk, start, reset;
reg [11:0] playerCards;
reg [11:0] dealerCards;
reg [29:0] communityCards;
wire [1:0] result;
wire [3:0] playerHand;
wire qualify;

// Instantiate the PokerHandEvaluation module
PokerHandEvaluation uut (
    .clk(clk),
    .start(start),
    .reset(reset),
    .playerCards(playerCards),
    .dealerCards(dealerCards),
    .communityCards(communityCards),
    .result(result),
    .playerHand(playerHand),
    .qualify(qualify)
);

// Clock generation
always #5 clk = ~clk; // 100 MHz clock (10 ns period)

// Test scenarios
initial begin
    // Monitor key outputs continuously
    $monitor("Time: %t, Result: %b, PlayerHand: %b, Qualify: %b", $time, result, playerHand, qualify);
    
    // Initialize
    clk = 0;
    reset = 1;  // Assert reset
    start = 0;
    #20;        // Hold reset for 20 ns
    
    reset = 0;  // Release reset
    #10;        // Wait 10 ns after reset
    
    // Test 1: Player has a straight flush
    playerCards = {6'd9, 6'd10}; // Jack, Queen (assuming hearts)
    dealerCards = {6'd15, 6'd16}; // 3, 4 (hearts)
    communityCards = {6'd17, 6'd18, 6'd19, 6'd11, 6'd12}; // 5, 6, 7 (hearts), 2, 3 of spades
    start = 1;
    #10; // Activate the start signal for 10 ns
    start = 0;
    #1000; // wait 1 us for processing - adjust based on your module's complexity and speed

    // The monitor will automatically display changes.
    // A delay after the last operation ensures all results are displayed before the simulation ends.
    #100; 

    // Test 2: Dealer wins with higher card
    playerCards = {6'd2, 6'd3}; // 3 and 4 of spades
    dealerCards = {6'd25, 6'd38}; // King and Ace of diamonds
    communityCards = {6'd8, 6'd21, 6'd34, 6'd47, 6'd9}; // 9, 10 of spades, 5 of clubs
    start = 1;
    #10; // Start the test
    start = 0;
    #1000; // wait 1 us for processing

    $finish;  // Terminate the simulation
end

endmodule
