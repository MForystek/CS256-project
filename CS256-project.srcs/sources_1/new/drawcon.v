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
    input [11*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_x, input [10*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_y,
    input [`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] killed,
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
    wire [11:0] cannon_rgb[`CANNONS_NUM-1:0];
    
    generate
        genvar h;
        for (h = 0; h < `CANNONS_NUM; h = h + 1) begin
            cannon_draw #(.CANNON_NUM(h)) cannon_draw (
                .draw_x(draw_x), .draw_y(draw_y),
                .cannon_rgb(cannon_rgb[h]));
        end
    endgenerate

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
// Enemies
// ----------------------------------------------------------------------------------------------------------    
    wire [11:0] enemy_rgb[`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    wire [11:0] enemy_pos_x[`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    wire [10:0] enemy_pos_y[`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    
    generate
        genvar k; genvar l;
        for (k = 0; k < `CANNONS_NUM; k = k + 1) begin
            for (l = 0; l < `ENEMIES_PER_CANNON; l = l + 1) begin
                enemy_draw enemy_draw(
                    .draw_x(draw_x), .draw_y(draw_y),
                    .enemy_pos_x(all_enemy_pos_x[11*`ENEMIES_PER_CANNON*k+11*l +: 11]),
                    .enemy_pos_y(all_enemy_pos_y[10*`ENEMIES_PER_CANNON*k+10*l +: 10]),
                    .killed(killed[`ENEMIES_PER_CANNON*k + l]),
                    .enemy_rgb(enemy_rgb[k][l]));
                assign enemy_pos_x[k][l] = all_enemy_pos_x[11*`ENEMIES_PER_CANNON*k+11*l +: 11];
                assign enemy_pos_y[k][l] = all_enemy_pos_y[10*`ENEMIES_PER_CANNON*k+10*l +: 10];
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
            for (jj = 0; jj < `ENEMIES_PER_CANNON; jj = jj + 1) begin
                if (enemy_rgb[ii][jj][11:8] != 4'h0) r = enemy_rgb[ii][jj][11:8];
            end
        end
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][11:8] != 4'h0) r = bullet_rgb[ii][jj][11:8];
            end
        end
        if (frame_r != 4'h0) r = frame_r;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            if (cannon_rgb[ii][11:8] != 4'h0) r = cannon_rgb[ii][11:8];
        end
        if (block_r != 4'h0) r = block_r;
        
        
        g = background_g;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][7:4] != 4'h0) g = bullet_rgb[ii][jj][7:4];
            end
        end
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `ENEMIES_PER_CANNON; jj = jj + 1) begin
                if (enemy_rgb[ii][jj][7:4] != 4'h0) g = enemy_rgb[ii][jj][7:4];
            end
        end
        if (frame_g != 4'h0) g = frame_g; 
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            if (cannon_rgb[ii][7:4] != 4'h0) g = cannon_rgb[ii][7:4];
        end
        if (block_g != 4'h0) g = block_g;        
        
        b = background_b;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj][3:0] != 4'h0) b = bullet_rgb[ii][jj][3:0];
            end
        end
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `ENEMIES_PER_CANNON; jj = jj + 1) begin
                if (enemy_rgb[ii][jj][3:0] != 4'h0) b = enemy_rgb[ii][jj][3:0];
            end
        end
        if (frame_b != 4'h0) b = frame_b;
        for (ii = 0; ii < `CANNONS_NUM; ii = ii + 1) begin
            if (cannon_rgb[ii][3:0] != 4'h0) b = cannon_rgb[ii][3:0];
        end
        if (block_b != 4'h0) b = block_b;
    end
    
endmodule