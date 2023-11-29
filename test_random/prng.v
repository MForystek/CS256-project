`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 04:30:03 PM
// Design Name: 
// Module Name: liner_feedback_shift_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Liner Feedback Shift Register (LFSR)
// Source: https://simplefpga.blogspot.com/2013/02/random-number-generator-in-verilog-fpga.html, access: November 23rd, 2023
`include <constants.v>


module prng (
    input clk, input rst,
    output reg [`DELAY_SIZE-1:0] rnd
    );

    reg [`DELAY_SIZE-1:0] random;
    reg [3:0] count; //to keep track of the shifts register size >= log2(DELAY_SIZE)

    wire feedback = random[14] ^ random[13];

    always @ (posedge clk) begin
        if (!rst) begin
            random <= `DELAY_SIZE'hF; //An LFSR cannot have an all 0 state, thus reset to FF
            count <= 4'd0;
        end else begin            
            random <= {random[`DELAY_SIZE-2:0], feedback}; //shift left the xor'd every posedge clock
            count <= count + 1'b1;
            
            if (count == `DELAY_SIZE) begin
                count <= 4'd0;
                rnd <= random; //assign the random number to output after DELAY_SIZE shifts
            end
        end
    end
    
endmodule



module lfsr #(parameter N = 10, SEED = 10'b1010101010, POS = 5) (
    input clk,
    input rst,
    output reg [N-1:0] random
);

    always @(posedge clk) begin
        if (rst) begin
            random <= SEED; // Initialize with a non-zero seed
        end else begin
            random <= {random[N-2:0], random[N-1] ^ random[POS]};
        end
    end

endmodule
