`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 12:12:50 PM
// Design Name: 
// Module Name: enemy_draw
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

module enemy_draw(
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] enemy_pos_x, input [9:0] enemy_pos_y,
    input killed,
    output [11:0] enemy_rgb
    );
    
    assign draw_enemy_x = draw_x >= enemy_pos_x && draw_x <= enemy_pos_x + `ENEMY_WIDTH;
    assign draw_enemy_y = draw_y >= enemy_pos_y && draw_y <= enemy_pos_y + `ENEMY_HEIGHT;
    
    localparam [3:0] enemy_r = 4'hF;
    localparam [3:0] enemy_g = 4'hF;
    localparam [3:0] enemy_b = 4'hF;
    
    assign enemy_rgb = !killed && draw_enemy_x && draw_enemy_y ? {enemy_r, enemy_g, enemy_b} : 12'h0;
endmodule