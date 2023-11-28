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
    input wire clk,
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] bullet_pos_x, input [9:0] bullet_pos_y,
    output reg [11:0] bullet_rgb
    );

    parameter SPRITE_ADDR_WIDTH = 11;
    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;

    bullet_sprite bullet_sprite1 (
        .clka(clk),
        .addra(address),
        .douta(sprite_data_out)
    );
    
    wire [10:0] next_pixel_x = draw_x + 2; // Account for 2 clock cycle delay
    wire [9:0] next_pixel_y = draw_y;
    always @(posedge clk) begin
        if (next_pixel_x >= bullet_pos_x && next_pixel_x <= bullet_pos_x + `BULLET_WIDTH &&
            next_pixel_y >= bullet_pos_y && next_pixel_y <= bullet_pos_y + `BULLET_HEIGHT) begin
            address <= ((next_pixel_y - bullet_pos_y) * `BULLET_WIDTH) + (next_pixel_x - bullet_pos_x);
            bullet_rgb <= sprite_data_out;
        end else begin
            bullet_rgb <= 12'h0;
        end
    end
endmodule

