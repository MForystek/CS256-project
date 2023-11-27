`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2023 02:03:01 PM
// Design Name: 
// Module Name: drawcon
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


module drawcon(
    input [10:0] blkpos_x, input [9:0] blkpos_y,
    input [10:0] draw_x, input [9:0] draw_y,
    output [3:0] r, output [3:0] g, output [3:0] b
    );
    reg [3:0] bg_r;
    reg [3:0] bg_g;
    reg [3:0] bg_b;
    
    always @ * begin
        if (draw_x < 11'd10 || draw_x > 11'd1269 || draw_y < 10'd10 || draw_y > 10'd789) begin
            bg_r = 4'b1111;
            bg_g = 4'b1111;
            bg_b = 4'b1111;
        end else begin
            bg_r = 4'b1111;
            bg_g = 4'b1111;
            bg_b = 4'b1010;
        end
    end
    
    reg [3:0] blk_r;
    reg [3:0] blk_g;
    reg [3:0] blk_b;
    
    always @ * begin
        if (draw_x >= blkpos_x && draw_x <= blkpos_x + 11'd32
         && draw_y >= blkpos_y && draw_y <= blkpos_y + 11'd32) begin
            blk_r = 4'b1110;
            blk_g = 4'b0010;
            blk_b = 4'b0010; 
        end else begin
            blk_r = 4'b0000;
            blk_g = 4'b0000;
            blk_b = 4'b0000;
        end
    end
    
    assign r = blk_r != 4'b0000 ? blk_r : bg_r;
    assign g = blk_g != 4'b0000 ? blk_g : bg_g;
    assign b = blk_b != 4'b0000 ? blk_b : bg_b;
    
endmodule