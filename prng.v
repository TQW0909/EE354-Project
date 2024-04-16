module prng(
    input clk,
    input reset,
    output reg [5:0] random_out
);

// 6-bit LFSR register initialization with a non-zero value
reg [5:0] lfsr_reg = 6'b000001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR to a non-zero initial state to avoid all zeros
        lfsr_reg <= 6'b000001;
    end else begin
        
        lfsr_reg <= {lfsr_reg[4:0], lfsr_reg[5] ^ lfsr_reg[4]};
    end
end

// Output the current state of LFSR
// Using a combinational block to continuously update output with the latest LFSR state.
always @* begin
    random_out = lfsr_reg;
end

endmodule
