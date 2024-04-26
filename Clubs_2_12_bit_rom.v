module empty_rom
	(
		input wire clk,
		input wire [5:0] row,
		input wire [5:0] col,
		output reg [11:0] color_data
	);

	(* rom_style = "block" *)

	//signal declaration
	reg [5:0] row_reg;
	reg [5:0] col_reg;

	always @(posedge clk)
		begin
		row_reg <= row;
		col_reg <= col;
		end
	wire [11:0] address = {row, col};
	always @(*) begin
		case(address)
			default: color_data = 12'b1111_1111_1111;
		endcase
	end
endmodule