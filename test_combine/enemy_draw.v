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
    input wire clk,
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] enemy_pos_x, input [9:0] enemy_pos_y,
    input killed,
    output reg [11:0] enemy_rgb
    );
    
    // assign draw_enemy_x = draw_x >= enemy_pos_x && draw_x <= enemy_pos_x + `ENEMY_WIDTH;
    // assign draw_enemy_y = draw_y >= enemy_pos_y && draw_y <= enemy_pos_y + `ENEMY_HEIGHT;
    
    // localparam [3:0] enemy_r = 4'hD;
    // localparam [3:0] enemy_g = 4'h2;
    // localparam [3:0] enemy_b = 4'h2;
    
    // assign enemy_rgb = !killed && draw_enemy_x && draw_enemy_y ? {enemy_r, enemy_g, enemy_b} : 12'h0;


    parameter SPRITE_ADDR_WIDTH = 16;
    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;

    enemy_sprite enemy_sprite1 (
        .clka(clk),
        .addra(address),
        .douta(sprite_data_out)
    );


    parameter BACKGROUND_WIDTH = 799;
    parameter BACKGROUND_HEIGHT = 1279;
    parameter BACKGROUND_ADDR_WIDTH = 20;

    wire [11:0] background_data_out;
    reg [BACKGROUND_ADDR_WIDTH-1:0] background_address;

    background_sprite background_sprite1 (
        .clka(clk),
        .addra(background_address),
        .douta(background_data_out)
    );
    
    wire [10:0] next_pixel_x = draw_x + 2; // Account for 2 clock cycle delay
    wire [9:0] next_pixel_y = draw_y;
    always @(posedge clk) begin
        if (next_pixel_x >= enemy_pos_x && next_pixel_x <= enemy_pos_x + `ENEMY_WIDTH &&
            next_pixel_y >= enemy_pos_y && next_pixel_y <= enemy_pos_y + `ENEMY_HEIGHT) begin
            address <= ((next_pixel_y - enemy_pos_y) * `ENEMY_WIDTH) + (next_pixel_x - enemy_pos_x);
            enemy_rgb <= sprite_data_out;
        end else begin
            // Output background color or keep the pixel transparent
            // background_address <= (next_pixel_y * BACKGROUND_WIDTH) + next_pixel_x;
            background_address <= ((next_pixel_y >> 1) * (`WIDTH >> 1)) + (next_pixel_x >> 1);
            enemy_rgb <= background_data_out
        end
    end
endmodule


/home/ly/main/courses/KAUST_CS256_HD/cs256-fall23/classproject/test_combine