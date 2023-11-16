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
`include <constants.v>

module drawcon(
    input [10:0] block_pos_x, input [9:0] block_pos_y,
    input [11*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_x, input [10*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_y,
    input [10:0] draw_x, input [9:0] draw_y,
    output reg [3:0] r, output reg [3:0] g, output reg [3:0] b
    );
// ----------------------------------------------------------------------------------------------------------    
// Frame and background
// ----------------------------------------------------------------------------------------------------------    
    localparam [3:0] background_r = 4'h4;
    localparam [3:0] background_g = 4'h8;
    localparam [3:0] background_b = 4'h5;
    
// ----------------------------------------------------------------------------------------------------------    
// Frame
// ----------------------------------------------------------------------------------------------------------        
    reg [3:0] frame_r;
    reg [3:0] frame_g;
    reg [3:0] frame_b;
    
    assign draw_frame = draw_x < `FRAME_WIDTH || draw_x > `WIDTH - `FRAME_WIDTH || draw_y < `FRAME_HEIGHT || draw_y > `HEIGHT - `FRAME_HEIGHT;
    
    always @ * begin
        if (draw_frame) begin
            frame_r = 4'hF;
            frame_g = 4'hF;
            frame_b = 4'hF;
        end else begin
            frame_r = 4'h0;
            frame_g = 4'h0;
            frame_b = 4'h0;
        end
    end
    
// ----------------------------------------------------------------------------------------------------------
// Moving block
// ----------------------------------------------------------------------------------------------------------
    reg [3:0] block_r;
    reg [3:0] block_g;
    reg [3:0] block_b;
    
    assign draw_block_x = draw_x >= block_pos_x && draw_x <= block_pos_x + `BLOCK_WIDTH;
    assign draw_block_y = draw_y >= block_pos_y && draw_y <= block_pos_y + `BLOCK_HEIGHT;
    
    always @ * begin
        if (draw_block_x && draw_block_y) begin
            block_r = 4'hE;
            block_g = 4'h2;
            block_b = 4'h2; 
        end else begin
            block_r = 4'h0;
            block_g = 4'h0;
            block_b = 4'h0;
        end
    end
    
// ----------------------------------------------------------------------------------------------------------    
// Cannons
// ----------------------------------------------------------------------------------------------------------        
    assign draw_cannon_x = draw_x >= `CANNON_OFFSET_X
        && draw_x <= `CANNON_OFFSET_X + `CANNON_WIDTH;
    assign draw_cannon1_y = draw_y >= `CANNON_OFFSET_Y 
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT;
    assign draw_cannon2_y = draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT + `CANNON_DISTANCE
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*2 + `CANNON_DISTANCE;    
    assign draw_cannon3_y = draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT*2 + `CANNON_DISTANCE*2 + 10'd1 
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*3 + `CANNON_DISTANCE*2 + 10'd1;
    assign draw_cannon4_y = draw_y >= `CANNON_OFFSET_Y + `CANNON_HEIGHT*3 + `CANNON_DISTANCE*3 + 10'd1 
        && draw_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*4 + `CANNON_DISTANCE*3 + 10'd1;
    
    localparam [3:0] cannon_r = 4'hE;
    localparam [3:0] cannon_g = 4'hB;
    localparam [3:0] cannon_b = 4'h5;
    
    wire [11:0] cannon1_rgb;
    wire [11:0] cannon2_rgb;
    wire [11:0] cannon3_rgb;
    wire [11:0] cannon4_rgb;    
    
    assign cannon1_rgb = draw_cannon_x && draw_cannon1_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;
    assign cannon2_rgb = draw_cannon_x && draw_cannon2_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;
    assign cannon3_rgb = draw_cannon_x && draw_cannon3_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;
    assign cannon4_rgb = draw_cannon_x && draw_cannon4_y ? {cannon_r, cannon_g, cannon_b} : 12'h0;

// ----------------------------------------------------------------------------------------------------------    
// Bullets    
// ----------------------------------------------------------------------------------------------------------    
    wire [11:0] bullet_rgb[`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    wire [11:0] bullet_pos_x[`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    wire [10:0] bullet_pos_y[`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    
    generate
        genvar i; genvar j;
        for (i = 0; i < `CANNONS_NUM; i = i + 1) begin
            for (j = 0; j < `BULLETS_PER_CANNON; j = j + 1) begin
                bullet_draw bullet_draw(
                    .draw_x(draw_x), .draw_y(draw_y),
                    .bullet_pos_x(all_bullet_pos_x[11*`BULLETS_PER_CANNON*i+11*j +: 11]),
                    .bullet_pos_y(all_bullet_pos_y[10*`BULLETS_PER_CANNON*i+10*j +: 10]),
                    .bullet_rgb(bullet_rgb[i][j]));
                assign bullet_pos_x[i][j] = all_bullet_pos_x[11*`BULLETS_PER_CANNON*i+11*j +: 11];
                assign bullet_pos_y[i][j] = all_bullet_pos_y[10*`BULLETS_PER_CANNON*i+10*j +: 10];
            end
        end
    endgenerate
    
// ----------------------------------------------------------------------------------------------------------    
// Assign final r, g, b values
// ----------------------------------------------------------------------------------------------------------    
    integer ii; integer jj;
    always @ * begin    
        r = background_r;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][11:8] != 4'h0) r = bullet_rgb[ii][jj][11:8];
            end
        end
        if (frame_r != 4'h0) r = frame_r;
        if (cannon4_rgb[11:8] != 4'h0) r = cannon4_rgb[11:8];
        if (cannon3_rgb[11:8] != 4'h0) r = cannon3_rgb[11:8];
        if (cannon2_rgb[11:8] != 4'h0) r = cannon2_rgb[11:8];
        if (cannon1_rgb[11:8] != 4'h0) r = cannon1_rgb[11:8];
        if (block_r != 4'h0) r = block_r;
        
        
        g = background_g;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][7:4] != 4'h0) g = bullet_rgb[ii][jj][7:4];
            end
        end
        if (frame_g != 4'h0) g = frame_g; 
        if (cannon4_rgb[7:4] != 4'h0) g = cannon4_rgb[7:4];
        if (cannon3_rgb[7:4] != 4'h0) g = cannon3_rgb[7:4];
        if (cannon2_rgb[7:4] != 4'h0) g = cannon2_rgb[7:4];
        if (cannon1_rgb[7:4] != 4'h0) g = cannon1_rgb[7:4];
        if (block_g != 4'h0) g = block_g;        
        
        b = background_b;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][3:0] != 4'h0) b = bullet_rgb[ii][jj][3:0];
            end
        end
        if (frame_b != 4'h0) b = frame_b;
        if (cannon4_rgb[3:0] != 4'h0) b = cannon4_rgb[3:0];
        if (cannon3_rgb[3:0] != 4'h0) b = cannon3_rgb[3:0];
        if (cannon2_rgb[3:0] != 4'h0) b = cannon2_rgb[3:0];
        if (cannon1_rgb[3:0] != 4'h0) b = cannon1_rgb[3:0];
        if (block_b != 4'h0) b = block_b;
    end
    
endmodule

module bullet_draw(
    input [10:0] draw_x, input [9:0] draw_y,
    input [10:0] bullet_pos_x, input [9:0] bullet_pos_y,
    output [11:0] bullet_rgb
    );
    
    assign draw_bullet_x = draw_x >= bullet_pos_x && draw_x <= bullet_pos_x + `BULLET_WIDTH;
    assign draw_bullet_y = draw_y >= bullet_pos_y && draw_y <= bullet_pos_y + `BULLET_HEIGHT;
    
    localparam [3:0] bullet_r = 4'h3;
    localparam [3:0] bullet_g = 4'h3;
    localparam [3:0] bullet_b = 4'h3;
    
    assign bullet_rgb = draw_bullet_x && draw_bullet_y ? {bullet_r, bullet_g, bullet_b} : 12'h0;
endmodule