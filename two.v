module two_rom
(
    input wire clk,
    input wire [2:0] row, // 3-bit row for 5 rows
    input wire [2:0] col, // 2-bit column for 3 columns
	input [5:0] card,
    output reg [11:0] color_data
);

// Define the colors
parameter BLACK = 12'b0000_0000_0000; // All bits off
parameter WHITE = 12'b1111_1111_1111; // All bits on

// Signal declaration for the ROM's current address

wire [5:0] address = {row, col}; // Combine row and col to form the 5-bit address



// Define the ROM content for the number "2"
always @(*) begin
	if(card % 13 == 0)begin//2
		case (address)
			//top bar
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			// Right-aligned top segment
			6'b001110: color_data = BLACK;
			//Center
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			
			//next
			6'b011000: color_data = BLACK;
			
			
			
			
			
			// Bottom bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100, 6'b100101: color_data = BLACK;
			6'b100000: color_data = BLACK;
			6'b100110: color_data = BLACK;
			
			default: color_data = WHITE;
		endcase
	end	
	if(card % 13 == 1) begin //3
		case (address)
			//top bar
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			// Right-aligned top segment
			6'b001110: color_data = BLACK;
			//Center
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			6'b011110: color_data = BLACK;
			// Bottom bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100, 6'b100101: color_data = BLACK;
			6'b100000: color_data = BLACK;
			6'b100110: color_data = BLACK;
			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 2) begin //4
		case (address)
			6'b000000: color_data = BLACK;
			6'b001000: color_data = BLACK;
			6'b001011: color_data = BLACK;
			
			//Center
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			//6'b011110: color_data = BLACK;
			
			6'b011011: color_data = BLACK;
			6'b100011: color_data = BLACK;
			default: color_data = WHITE;
		endcase		
	end
	if(card % 13 == 3)begin //5
		case(address)
			//top bar
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			
			6'b001000: color_data = BLACK;
			
			//Center
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			
			6'b011110: color_data = BLACK;
			
			//low bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100, 6'b100101: color_data = BLACK;
			6'b100000: color_data = BLACK;
			6'b100110: color_data = BLACK;
			
			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 4)begin //6 YOU are left here
		case(address)
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			
			//Single
			6'b001000: color_data = BLACK;
			
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			
			//Singles
			6'b011000: color_data = BLACK;
			6'b011110: color_data = BLACK;
			
			//low bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100, 6'b100101: color_data = BLACK;
			6'b100000: color_data = BLACK;
			6'b100110: color_data = BLACK;
			
			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 5)begin //7
		case(address)
			//top bar
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			
			//Singles
			6'b001110, 6'b010110, 6'b011110, 6'b100110: color_data = BLACK;
			
			default: color_data = WHITE;
		endcase		
	end
	if(card % 13 == 6)begin //8
		case(address)
			6'b000001, 6'b000010, 6'b000011, 6'b000100, // Top bar
			6'b010001, 6'b010010, 6'b010011, 6'b010100, // Middle bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100: // Bottom bar
				color_data = BLACK;

			// Row 1 and Row 3 - Vertical ends, all black
			6'b001000, 6'b001101, // Ends of Row 1
			6'b011000, 6'b011101: // Ends of Row 3
				color_data = BLACK;

			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 7)begin //9
		case(address)
			//top bar
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			
			//Singles
			6'b001000: color_data = BLACK;
			6'b001110: color_data = BLACK;
			
			//center bar
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;
			
			//Single
			6'b011110: color_data = BLACK;
			
			//low bar
			6'b100001, 6'b100010, 6'b100011, 6'b100100, 6'b100101: color_data = BLACK;
			6'b100000: color_data = BLACK;
			6'b100110: color_data = BLACK;
			

			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 8)begin //10
		case(address)
			6'b000001, 6'b000100, 6'b000101, 6'b000110: color_data = BLACK;
			6'b001001, 6'b001100, 6'b001110: color_data = BLACK;
			
			6'b010001, 6'b010100, 6'b010110: color_data = BLACK;
			
			6'b011001, 6'b011100, 6'b011110: color_data = BLACK;
			
			6'b100001, 6'b100100, 6'b100101, 6'b100110: color_data = BLACK;
			
			
			

			default: color_data = WHITE; 
		endcase
			
	end
	if(card % 13 == 9)begin // J
		case(address)
			// Row 0 - Top horizontal segment
			6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			// Row 1 & 2 - Right vertical segment
			6'b001101, 6'b010101: color_data = BLACK;
			// Row 3 - Hook starting
			6'b011000, 6'b011101: color_data = BLACK;
			// Row 4 - Bottom horizontal bar to complete the hook
			6'b100001, 6'b100010, 6'b100011, 6'b100100: color_data = BLACK;

			default: color_data = WHITE;
		endcase
			
	end
	if(card % 13 == 10)begin //Q
		case(address)
			// Top bar
			6'b000000, 6'b000101, 6'b000110: color_data = BLACK;
			6'b000001, 6'b000010, 6'b000011, 6'b000100: color_data = BLACK;
			6'b001000, 6'b010000, 6'b011000: color_data = BLACK;
			
			6'b001110: color_data = BLACK;
			6'b010110: color_data = BLACK;
			6'b011001, 6'b011010, 6'b011011, 6'b011100, 6'b011101, 6'b011110: color_data = BLACK;
			
			6'b100100: color_data = BLACK;

			default: color_data = WHITE; 
		endcase
			
	end
	if(card % 13 == 11) begin //K
		case(address)
			6'b000000, 6'b001000, 6'b010000, 6'b011000, 6'b100000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b000011: color_data = BLACK;
			6'b001010: color_data = BLACK;
			6'b011010: color_data = BLACK;
			6'b100011: color_data = BLACK;
			default: color_data = WHITE; 
		endcase
			
	end
	if(card % 13 == 12)begin // A
		case(address)
			6'b000000, 6'b000001, 6'b000010, 6'b000011, 6'b000100, 6'b000101: color_data = BLACK;
			6'b000110: color_data = BLACK;
			
			6'b001000, 6'b010000, 6'b010000, 6'b011000, 6'b100000: color_data = BLACK;
			
			6'b000110, 6'b001110, 6'b010110, 6'b011110, 6'b100110: color_data = BLACK;
			
			//center bar
			6'b010110: color_data = BLACK;
			6'b010000: color_data = BLACK;
			6'b010001: color_data = BLACK;
			6'b010010: color_data = BLACK;
			6'b010011: color_data = BLACK;
			6'b010100: color_data = BLACK;
			6'b010101: color_data = BLACK;

			default: color_data = WHITE;
		endcase
			
	end
        

        
    
end

endmodule
