`timescale 1ns / 1ps

module drawsprite(
    input wire clk,
    input wire [10:0] pixel_x, input wire [9:0] pixel_y,
    input wire [10:0] next_pixel_x, input wire [9:0] next_pixel_y,
    input wire [10:0] sprite_pos_x, input wire [9:0] sprite_pos_y,
    output reg [3:0] red_sprite, output reg [3:0] green_sprite, output reg [3:0] blue_sprite
);
    // may need to read from the .coe file's dimensions
    parameter SPRITE_WIDTH = 88;
    parameter SPRITE_HEIGHT = 108;
    parameter SPRITE_ADDR_WIDTH = 16;

    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;
    
    palm_sprite palm_sprite1 (
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
    
    always @(posedge clk) begin
        if (next_pixel_x >= sprite_pos_x && next_pixel_x < sprite_pos_x + SPRITE_WIDTH &&
            next_pixel_y >= sprite_pos_y && next_pixel_y < sprite_pos_y + SPRITE_HEIGHT) begin
            address <= ((next_pixel_y - sprite_pos_y) * SPRITE_WIDTH) + (next_pixel_x - sprite_pos_x);
            // Output sprite data
            red_sprite <= sprite_data_out[11:8];
            green_sprite <= sprite_data_out[7:4];
            blue_sprite <= sprite_data_out[3:0];
        end else begin
            // Output background color or keep the pixel transparent
            // background_address <= (next_pixel_y * BACKGROUND_WIDTH) + next_pixel_x;
            background_address <= ((next_pixel_y >> 1) * (BACKGROUND_WIDTH >> 1)) + (next_pixel_x >> 1);
            red_sprite <= background_data_out[11:8];
            green_sprite <= background_data_out[7:4];
            blue_sprite <= background_data_out[3:0];
        end
    end
endmodule
