

module generate_random_list #(parameter num_bits = 10, SEED = 10'b1010101010, POS = 5)(
    input clk, input rst,
    output reg [N-1:0] random_number
);
    reg [N-1:0] random_numbers[`CANNONS_NUM * `ENEMIES_PER_CANNON - 1:0];
    integer i;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Initialize the LFSR and the array
            lfsr_reg <= SEED; // Non-zero seed
            for (i = 0; i < `CANNONS_NUM * `ENEMIES_PER_CANNON; i = i + 1) begin
                random_numbers[i] <= 0; 
            end
        end else begin
            // Update the LFSR
            lfsr_reg <= {lfsr_reg[N-2:0], feedback}; // feedback is the XOR of tap positions
            // Store the random number in the array
            random_numbers[count] <= lfsr_reg;
        end
    end
endmodule