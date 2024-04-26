module card_game(
    input clk,
    input reset,
    input draw_card,   // Signal to draw multiple cards
    output reg [53:0] dealt_cards,  // Outputs the array of card numbers
    output reg all_cards_dealt  // Indicates all required cards have been dealt
);

localparam NUM_CARDS = 52;
localparam NUM_DEALS = 9; // Total cards to deal at once
reg [5:0] deck[0:NUM_CARDS-1];  // Array of cards
reg [5:0] random_index;  // Randomly generated index
integer is_random;
integer deal_count;  // Counter for the number of cards dealt
integer each_bit;
integer i;

// PRNG instance
wire [5:0] random_value;
prng random_val_gen(.clk(clk), .reset(reset), .random_out(random_value));

initial begin
    for (i = 0; i < 52; i = i + 1) begin
        deck[i] = i; // Initialize deck
    end
	
end

always @(posedge clk) begin
    if (reset) begin
        deal_count <= 0;
        all_cards_dealt <= 0;
		is_random <= 0;
    end
	else if(!is_random) begin
		random_index <= random_value % NUM_CARDS;
		is_random <= 1;
	end
	else if (draw_card && deal_count < 54) begin
		if(random_index > 51)begin
			is_random <= 0;
		end
		else if(each_bit < 6) begin
			dealt_cards[deal_count] <= deck[random_index][each_bit];  // Assign the card value
			deal_count <= deal_count + 1;
			each_bit <= each_bit + 1;
		end
		else if(each_bit >= 6) begin
			each_bit <= 0;
			is_random <= 0;
		end
        
        if (deal_count == 53) begin
            all_cards_dealt <= 1;  // Signal that all cards have been dealt
        end
    end else if (!draw_card) begin
        deal_count <= 0;  // Reset deal count if draw_card is not active
        all_cards_dealt <= 0;  // Reset dealt status
		each_bit <= 0;
		//is_random <= 0;
    end
end

endmodule