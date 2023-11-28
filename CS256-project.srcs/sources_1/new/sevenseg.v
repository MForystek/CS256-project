`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2023 11:47:03 PM
// Design Name: 
// Module Name: sevenseg
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


module sevenseg (
    input [4:0] num,
    output a, output b, output c,
    output d, output e, output f,
    output g
    );
    wire [6:0] digit;
    sevenseg_unified seg_unified(.num(num), .digit(digit[6:0]));
    assign a = digit[6];
    assign b = digit[5];
    assign c = digit[4];
    assign d = digit[3];
    assign e = digit[2];
    assign f = digit[1];
    assign g = digit[0];
endmodule

module sevenseg_unified(input [4:0] num, output reg [6:0] digit);
    always @ *
        begin
            case (num)
                5'd0    : digit = 7'b0000001; // 0
                5'd1    : digit = 7'b1001111; // 1
                5'd2    : digit = 7'b0010010; // 2
                5'd3    : digit = 7'b0000110; // 3
                5'd4    : digit = 7'b1001100; // 4
                5'd5    : digit = 7'b0100100; // 5
                5'd6    : digit = 7'b0100000; // 6
                5'd7    : digit = 7'b0001111; // 7
                5'd8    : digit = 7'b0000000; // 8
                5'd9    : digit = 7'b0000100; // 9
                5'd10   : digit = 7'b0001000; // A
                5'd11   : digit = 7'b1100000; // b
                5'd12   : digit = 7'b0110001; // C
                5'd13   : digit = 7'b1000010; // d
                5'd14   : digit = 7'b0110000; // E
                5'd15   : digit = 7'b0111000; // f
                //--------------------------------
                5'd16   : digit = 7'b1110001; // L
                5'd17   : digit = 7'b1101010; // n
                5'd18   : digit = 7'b0011000; // P
                5'd19   : digit = 7'b1000100; // y
                default : digit = 7'b1111111; // _
            endcase
        end
endmodule
