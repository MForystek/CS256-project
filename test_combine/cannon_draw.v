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
    input wire clk,
    input [10:0] draw_x, input [9:0] draw_y,
    output [11:0] cannon_rgb
    );
    assign draw_cannon_x = draw_x >= `CANNON_OFFSET_X
        && draw_x <= `CANNON_OFFSET_X + `CANNON_WIDTH;
    assign draw_cannon_y = draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT*CANNON_NUM + `CANNON_DISTANCE*CANNON_NUM 
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*(CANNON_NUM+1) + `CANNON_DISTANCE*CANNON_NUM;
    
    localparam [3:0] cannon_r = 4'hE;
    localparam [3:0] cannon_g = 4'hB;
    localparam [3:0] cannon_b = 4'h5;
    
    assign cannon_rgb = draw_cannon_x && draw_cannon_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;

    // wire [11:0] sprite_data_out;
    // reg [`SPRITE_ADDR_WIDTH-1:0] address;

    // cannon_sprite cannon_sprite1 (
    //     .clka(clk),
    //     .addra(address),
    //     .douta(sprite_data_out)
    // );
    
    // wire [10:0] next_pixel_x = draw_x + 2; // Account for 2 clock cycle delay
    // wire [9:0] next_pixel_y = draw_y;
    // always @(posedge clk) begin
    //     if (draw_x >= `CANNON_OFFSET_X && draw_x <= `CANNON_OFFSET_X + `CANNON_WIDTH &&
    //         draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT*CANNON_NUM + `CANNON_DISTANCE*CANNON_NUM 
    //         && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*(CANNON_NUM+1) + `CANNON_DISTANCE*CANNON_NUM) begin
    //         address <= ((next_pixel_y - `CANNON_OFFSET_X) * `CANNON_HEIGHT) + (next_pixel_x - `CANNON_OFFSET_Y);
    //         cannon_rgb <= sprite_data_out;
    //     end else begin
    //         address <= `SPRITE_ADDR_WIDTH'd0;
    //         cannon_rgb <= 12'h0;
    //     end
    // end
endmodule


