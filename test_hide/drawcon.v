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
    //input [10:0] block_pos_x, input [9:0] block_pos_y,
    input pixclk,
    input [11*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_x,
    input [10*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_y,
    input [11*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_x,
    input [10*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_y,
    input [`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] killed,
    input [10:0] draw_x, input [9:0] draw_y,
    output [3:0] r, output [3:0] g, output [3:0] b
    );
// ----------------------------------------------------------------------------------------------------------    
// Background
// ----------------------------------------------------------------------------------------------------------    
    reg [11:0] background_rgb = 12'h485;
    
    parameter BACKGROUND_ADDR_WIDTH = 20;

    wire [11:0] background_data_out;
    reg [BACKGROUND_ADDR_WIDTH-1:0] background_address;

    background_sprite background_sprite (
        .clka(pixclk),
        .addra(background_address),
        .douta(background_data_out)
    );
    reg [10:0] next_pixel_x;
    reg [9:0] next_pixel_y;
    always @(posedge pixclk) begin
        next_pixel_x <= draw_x + 11'd2; // Account for 2 clock cycle delay
        next_pixel_y <= draw_y;
        
        background_address <= ((next_pixel_y >> 3) * (`WIDTH >> 3)) + (next_pixel_x >> 3);
        background_rgb <= background_data_out;
    end
    
// ----------------------------------------------------------------------------------------------------------    
// Frame
// ----------------------------------------------------------------------------------------------------------
    wire draw_frame = draw_x < `FRAME_WIDTH || draw_x > `WIDTH - `FRAME_WIDTH 
                     || draw_y < `FRAME_HEIGHT || draw_y > `HEIGHT - `FRAME_HEIGHT;
    wire [11:0] frame_rgb = draw_frame ? 12'h000 : `MASK;
    
// ----------------------------------------------------------------------------------------------------------
// Moving block
// ----------------------------------------------------------------------------------------------------------
//    wire draw_block = draw_x >= block_pos_x && draw_x <= block_pos_x + `BLOCK_WIDTH
//                     && draw_y >= block_pos_y && draw_y <= block_pos_y + `BLOCK_HEIGHT;
//    wire [11:0] block_rgb = draw_block ? 12'hE22 : 12'h000;
    
// ----------------------------------------------------------------------------------------------------------    
// Cannons
// ----------------------------------------------------------------------------------------------------------        
    wire [11:0] cannon_rgb[`CANNONS_NUM-1:0];
    
    generate
        genvar h;
        for (h = 1; h < `CANNONS_NUM; h = h + 1) begin
            cannon_draw #(.CANNON_NUM(h)) cannon_draw (
                .pixclk(pixclk),
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
        for (i = 1; i < `CANNONS_NUM; i = i + 1) begin
            for (j = 0; j < `BULLETS_PER_CANNON; j = j + 1) begin
                bullet_draw bullet_draw(
                    .pixclk(pixclk),
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
        for (k = 1; k < `CANNONS_NUM; k = k + 1) begin
            for (l = 0; l < `ENEMIES_PER_CANNON; l = l + 1) begin
                enemy_draw enemy_draw(
                    .pixclk(pixclk),
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
    reg [11:0] rgb;
    
    integer ii; integer jj;
    always @ * begin
        rgb = background_rgb;
        
        for (ii = 1; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `ENEMIES_PER_CANNON; jj = jj + 1) begin
                if (enemy_rgb[ii][jj] != `MASK) rgb = enemy_rgb[ii][jj];
            end 
        end
        
        for (ii = 1; ii < `CANNONS_NUM; ii = ii + 1) begin
            for (jj = 0; jj < `BULLETS_PER_CANNON; jj = jj + 1) begin
                if (bullet_rgb[ii][jj] != `MASK) rgb = bullet_rgb[ii][jj];
            end
        end
        
        if (frame_rgb != `MASK) rgb = frame_rgb;
        
        for (ii = 1; ii < `CANNONS_NUM; ii = ii + 1) begin
            if (cannon_rgb[ii] != `MASK) rgb = cannon_rgb[ii];
        end
        
        //if (block_rgb != `MASK) rgb = block_rgb;
    end
    
    assign {r, g, b} = rgb;
    
endmodule