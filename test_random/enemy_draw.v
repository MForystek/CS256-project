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
    input pixclk,
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] enemy_pos_x, input [9:0] enemy_pos_y,
    input killed,
    output reg [11:0] enemy_rgb
    );
    
    parameter SPRITE_ADDR_WIDTH = 16;
    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;

    enemy1_sprite enemy1_sprite (
        .clka(pixclk),
        .addra(address),
        .douta(sprite_data_out)
    );
    
    reg [10:0] next_pixel_x;
    reg [9:0] next_pixel_y;
    
    assign draw_enemy_x = draw_x >= enemy_pos_x && draw_x <= enemy_pos_x + `ENEMY_WIDTH;
    assign draw_enemy_y = draw_y >= enemy_pos_y && draw_y <= enemy_pos_y + `ENEMY_HEIGHT;
    
    always @(posedge pixclk) begin
        next_pixel_x <= draw_x + 11'd2; // Account for 2 clock cycle delay
        next_pixel_y <= draw_y;
    
        if (draw_enemy_x && draw_enemy_y) begin
            address <= ((next_pixel_y - enemy_pos_y) * `ENEMY_WIDTH) + (next_pixel_x - enemy_pos_x);
            enemy_rgb <= sprite_data_out;
        end else begin
            enemy_rgb <= `MASK;
        end
    end
    
//    localparam [3:0] enemy_r = 4'hD;
//    localparam [3:0] enemy_g = 4'h2;
//    localparam [3:0] enemy_b = 4'h2;
    
//    assign enemy_rgb = !killed && draw_enemy_x && draw_enemy_y ? {enemy_r, enemy_g, enemy_b} : `MASK;
endmodule