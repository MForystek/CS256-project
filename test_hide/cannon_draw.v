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
    
//    localparam [3:0] cannon_r = 4'hE;
//    localparam [3:0] cannon_g = 4'hB;
//    localparam [3:0] cannon_b = 4'h5;
    
//    assign cannon_rgb = draw_cannon_x && draw_cannon_y ? {cannon_r, cannon_g, cannon_b} : `MASK;
endmodule
