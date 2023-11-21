`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 12:47:08 PM
// Design Name: 
// Module Name: cannon_draw
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


module cannon_draw #(parameter CANNON_NUM = 0) (
    input [10:0] draw_x, input [9:0] draw_y,
    output [11:0] cannon_rgb
    );
    assign draw_cannon_x = draw_x >= `CANNON_OFFSET_X
        && draw_x <= `CANNON_OFFSET_X + `CANNON_WIDTH;
    assign draw_cannon_y = draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT*CANNON_NUM + `CANNON_DISTANCE*CANNON_NUM 
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*(CANNON_NUM+1) + `CANNON_DISTANCE*CANNON_NUM;
    
    localparam [3:0] cannon_r = 4'hE;
    localparam [3:0] cannon_g = 4'hB;
    localparam [3:0] cannon_b = 4'h5;
    
    assign cannon_rgb = draw_cannon_x && draw_cannon_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;
endmodule
