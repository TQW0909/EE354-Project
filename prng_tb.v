`timescale 1ns / 1ps

module tb_card_game;


reg clk;
reg reset;

// Input signal to trigger card draw
reg draw_card;

// Outputs from the card_game module
wire [53:0] dealt_cards;
wire all_cards_dealt;

// Instantiate the card_game module
card_game uut_card_game (
    .clk(clk),
    .reset(reset),
    .draw_card(draw_card),
    .dealt_cards(dealt_cards),
    .all_cards_dealt(all_cards_dealt)
);


initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Generate a 100MHz clock
end


initial begin
    
    reset = 1;
    draw_card = 0;
    #10; 

    reset = 0;
    #10; 
    
    repeat (10) begin
        
        #10; // Simulate pressing the draw_card button
        draw_card = 1;
        #50; 
    end
	
    $finish;  
end


initial begin
	
    $display("Time = %t, Dealt Card = %d, All Cards Dealt = %b",
             $time, dealt_cards, all_cards_dealt);
end

endmodule
