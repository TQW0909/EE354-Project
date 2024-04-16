module card_game(
    input clk,
    input reset,
    input draw_card,   // Signal to draw multiple cards
    output reg [5:0] dealt_cards[8:0],  // Outputs the array of card numbers
    output reg all_cards_dealt  // Indicates all required cards have been dealt
);

localparam NUM_CARDS = 52;
localparam NUM_DEALS = 9; // Total cards to deal at once
reg [5:0] deck[NUM_CARDS-1:0];  // Array of cards
reg [5:0] random_index;  // Randomly generated index
integer deal_count;  // Counter for the number of cards dealt

// PRNG instance
wire [5:0] random_value;
prng random_val_gen(.clk(clk), .reset(reset), .random_out(random_value));

initial begin
    for (integer i = 0; i < NUM_CARDS; i = i + 1) begin
        deck[i] = i;  // Initialize deck
    end
end

always @(posedge clk) begin
    if (reset) begin
        deal_count <= 0;
        all_cards_dealt <= 0;
    end else if (draw_card && deal_count < NUM_DEALS) begin
        random_index <= random_value % NUM_CARDS;
        dealt_cards[deal_count] <= deck[random_index];  // Assign the card value
        deal_count <= deal_count + 1;
        if (deal_count == NUM_DEALS) begin
            all_cards_dealt <= 1;  // Signal that all cards have been dealt
        end
    end else if (!draw_card) begin
        deal_count <= 0;  // Reset deal count if draw_card is not active
        all_cards_dealt <= 0;  // Reset dealt status
    end
end

endmodule
