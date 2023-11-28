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


module prng #(parameter SEED = `RNG_SIZE'hF) (
    input clk, input rst,
    output reg [`RNG_SIZE-1:0] rnd
    );

    reg [`RNG_SIZE-1:0] random;
    reg [`LOG_RNG_SIZE-1:0] count; //to keep track of the shifts register size >= log2(RNG_SIZE)

    wire feedback = random[15] ^ random[14] ^ random[12] ^ random[3];

    always @ (posedge clk) begin
        if (!rst) begin
            random <= SEED; //An LFSR cannot have an all 0 state, thus reset to SEED
            count <= `LOG_RNG_SIZE'd0;
        end else begin           
            random <= {random[`RNG_SIZE-2:0], feedback}; //shift left the xor'd every posedge clock
            count <= count + 1'b1;
            
            if (count == `RNG_SIZE) begin
                count <= `LOG_RNG_SIZE'd0;
                rnd <= random; //assign the random number to output after RNG_SIZE shifts
            end
        end
    end
    
endmodule

