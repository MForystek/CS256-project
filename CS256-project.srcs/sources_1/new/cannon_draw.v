`timescale 1ns / 1ps

module cannon_draw #(parameter CANNON_NUM = 0) (
    input pixclk,
    input [10:0] draw_x, input [9:0] draw_y,
    output reg [11:0] cannon_rgb
    );
    
    parameter SPRITE_ADDR_WIDTH = 16;
    wire [11:0] sprite_data_out;
    reg [SPRITE_ADDR_WIDTH-1:0] address;
    
    cannon_sprite cannon_sprite (
        .clka(pixclk),
        .addra(address),
        .douta(sprite_data_out)
    );
    
    reg [10:0] next_pixel_x;
    reg [9:0] next_pixel_y;
    
    wire [10:0] cannon_pos_x = `CANNON_OFFSET_X;
    wire [9:0] cannon_pos_y = `CANNON_OFFSET_Y + `CANNON_HEIGHT*CANNON_NUM + `CANNON_DISTANCE*CANNON_NUM;
    
    assign draw_cannon_x = draw_x >= cannon_pos_x && draw_x <= cannon_pos_x + `CANNON_WIDTH;
    assign draw_cannon_y = draw_y >= cannon_pos_y && draw_y <= cannon_pos_y + `CANNON_HEIGHT;
    
    always @(posedge pixclk) begin
        next_pixel_x <= draw_x + 11'd2; // Account for 2 clock cycle delay
        next_pixel_y <= draw_y;
        
        if (draw_cannon_x && draw_cannon_y) begin
            address <= ((next_pixel_y - cannon_pos_y) * `CANNON_WIDTH) + (next_pixel_x - cannon_pos_x);
            cannon_rgb <= sprite_data_out;
        end else begin
            cannon_rgb <= `MASK;
        end
    end
    
endmodule
