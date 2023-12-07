`timescale 1ns / 1ps

`include <constants.v>

module bullet_draw(
    input pixclk,
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] bullet_pos_x, input [9:0] bullet_pos_y,
    output reg [11:0] bullet_rgb
    );
    
    parameter SPRITE_ADDR_WIDTH = 16;
    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;

    bullet_sprite bullet_sprite (
        .clka(pixclk),
        .addra(address),
        .douta(sprite_data_out)
    );
    
    reg [10:0] next_pixel_x;
    reg [9:0] next_pixel_y;
    
    assign draw_bullet_x = draw_x >= bullet_pos_x && draw_x <= bullet_pos_x + `BULLET_WIDTH;
    assign draw_bullet_y = draw_y >= bullet_pos_y && draw_y <= bullet_pos_y + `BULLET_HEIGHT;
    
    always @(posedge pixclk) begin
        next_pixel_x <= draw_x + 11'd2; // Account for 2 clock cycle delay
        next_pixel_y <= draw_y;
    
        if (draw_bullet_x && draw_bullet_y) begin
            address <= ((next_pixel_y - bullet_pos_y) * `BULLET_WIDTH) + (next_pixel_x - bullet_pos_x);
            bullet_rgb <= sprite_data_out;
        end else begin
            bullet_rgb <= `MASK;
        end
    end
    
endmodule
