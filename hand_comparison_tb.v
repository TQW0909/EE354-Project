`timescale 1ns / 1ps

module PokerHandEvaluation_tb;

reg clk, start, reset;
reg [11:0] playerCards;
reg [11:0] dealerCards;
reg [29:0] communityCards;
wire [1:0] result;
wire [3:0] playerHand;
wire done;
wire qualify;
integer wait_cycles;
integer MAX_WAIT_CYCLES;

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
    .qualify(qualify),
	.done(done)
);


always #5 clk = ~clk; // 100 MHz clock (10 ns period)

initial begin

    $monitor("Time: %t, Result: %d, PlayerHand: %d, Qualify: %d, Done: %d", $time, result, playerHand, qualify, done);
    
    // Initialize
    clk = 0;
    reset = 1;  // Assert reset
    start = 0;
    #20;        // Hold reset for 20 ns
    
    reset = 0;  // Release reset
    #10;        // Wait 10 ns after reset
    
    // Test
    playerCards = {6'd12, 6'd0}; 
    dealerCards = {6'd25, 6'd2}; 
    communityCards = {6'd11, 6'd9, 6'd7, 6'd6, 6'd1}; 
    start = 1;
    #10;
    start = 0;
    wait (done == 1); 

	$finish;

end

endmodule
