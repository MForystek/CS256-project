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
    
    palm palm1 (
        .clka(clk),
        .addra(address),
        .douta(sprite_data_out)
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
            red_sprite <= 4'b0000;
            green_sprite <= 4'b0000;
            blue_sprite <= 4'b0000;
        end
    end
endmodule
