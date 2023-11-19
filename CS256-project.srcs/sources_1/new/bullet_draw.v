`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 12:14:33 AM
// Design Name: 
// Module Name: bullet_draw
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
`include <constants.v>

module bullet_draw(
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] bullet_pos_x, input [9:0] bullet_pos_y,
    output [11:0] bullet_rgb
    );
    
    assign draw_bullet_x = draw_x >= bullet_pos_x && draw_x <= bullet_pos_x + `BULLET_WIDTH;
    assign draw_bullet_y = draw_y >= bullet_pos_y && draw_y <= bullet_pos_y + `BULLET_HEIGHT;
    
    localparam [3:0] bullet_r = 4'h3;
    localparam [3:0] bullet_g = 4'h3;
    localparam [3:0] bullet_b = 4'h3;
    
    assign bullet_rgb = draw_bullet_x && draw_bullet_y ? {bullet_r, bullet_g, bullet_b} : 12'h0;
endmodule
