module card_game(
    input clk,
    input reset,
    input draw_card,  // Signal to draw a card
    output reg [5:0] dealt_card,  // Outputs the card number
    output reg valid_card  // Indicates if the dealt card is valid
);

// Constants and Registers
localparam NUM_CARDS = 52;
reg [5:0] deck[NUM_CARDS-1:0];  // Array of cards
reg [NUM_CARDS-1:0] dealt_flags;  // Dealing flags for each card
reg [5:0] random_index;  // Randomly generated index

// PRNG instance (Assuming you have a module ready for generating random numbers)
wire [5:0] random_value;  // Connect this to a PRNG module
prng random_val_gen(.clk(clk), .reset(reset), .random_out(random_value));

// Initialize the deck and flags
integer i;
initial begin
    for (i = 0; i < NUM_CARDS; i = i + 1) begin
        deck[i] = i;  // Set each card's unique identifier
        dealt_flags[i] = 0;  // All cards are initially not dealt
    end
end

// Handle card drawing
always @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < NUM_CARDS; i = i + 1)
            dealt_flags[i] <= 0;
    end else if (draw_card) begin
        random_index <= random_value % NUM_CARDS;  
        if (!dealt_flags[random_index]) begin  // Check if the card has not been dealt
            dealt_card <= deck[random_index];  // Assign the card value
            dealt_flags[random_index] <= 1;  // Mark this card as dealt
            valid_card <= 1;  
        end else begin
            valid_card <= 0;  // No valid card was dealt, all are taken or collision
        end
    end
end

endmodule
