`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 04:54:39 PM
// Design Name: 
// Module Name: game_top
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

module game_top(
    input clk, input rst, input [`CANNONS_NUM-1:0] cannons_on,
    input btn_u, input btn_d, input btn_l, input btn_r, input btn_c,
    output [3:0] pix_r, output [3:0] pix_g, output [3:0] pix_b,
    output hsync, output vsync
    );
    
    wire pixclk, prelogclk;
    
    wire [10:0] curr_x;
    wire [9:0] curr_y;
    
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;

    clk_wiz_0 clock_wizard(.clk_in1(clk), .clk_out1(pixclk), .clk_out2(prelogclk));
    
    vga_out vga(.clk(pixclk), .rst(rst), .red(red), .green(green), .blue(blue),
                .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),
                .hsync(hsync), .vsync(vsync), .curr_x(curr_x), .curr_y(curr_y));
    
    reg [16:0] logclk;
    
    always @ (posedge prelogclk) begin
        if (!rst || logclk >= 17'd78776)
            logclk <= 17'd0;
        else
            logclk <= logclk + 1'b1;
    end

// ----------------------------------------------------------------------------------------------------------
// Moving block
// ----------------------------------------------------------------------------------------------------------    
    reg [10:0] block_pos_x;
    reg [9:0] block_pos_y;
    
    always @ (posedge logclk[16]) begin
        if (!rst || btn_c) begin
            block_pos_x <= 11'd623;
            block_pos_y <= 10'd383;
        end else begin            
            if (btn_u)
                block_pos_y <= block_pos_y <= `FRAME_HEIGHT + 10'd1 ? `FRAME_WIDTH + 10'd1 : block_pos_y - `BLOCK_SPEED_Y;
            else if (btn_d)
                block_pos_y <= block_pos_y >= `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1 ? `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1 : block_pos_y + `BLOCK_SPEED_Y;
            else if (block_pos_y <= `FRAME_HEIGHT + 10'd1)
                block_pos_y <= `FRAME_HEIGHT + 10'd1;
            else if (block_pos_y >= `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1)
                block_pos_y <=  `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1;
            
            if (btn_l)
                block_pos_x <= block_pos_x <= `FRAME_WIDTH + 11'd1 ? `FRAME_WIDTH + 11'd1 : block_pos_x - `BLOCK_SPEED_X;
            else if (btn_r)
                block_pos_x <= block_pos_x >= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1 ? `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1 : block_pos_x + `BLOCK_SPEED_X;
            else if (block_pos_x <= `FRAME_WIDTH + 11'd1)
                block_pos_x <= `FRAME_WIDTH + 11'd1;
            else if (block_pos_x >= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1)
                block_pos_x <= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1;
        end
    end

// ----------------------------------------------------------------------------------------------------------    
// Shooting bullets
// ----------------------------------------------------------------------------------------------------------       
    wire [10:0] bullet_pos_x [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    wire [9:0] bullet_pos_y [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    
    wire [11*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_x;
    wire [10*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_y;
    
    generate
        genvar i; genvar j;
        for (i = 0; i < `CANNONS_NUM; i = i + 1) begin
            for (j = 0; j < `BULLETS_PER_CANNON; j = j + 1) begin
                bullet #(.FROM_CANNON(i), .BULLET_NUM(j)) bullet (
                    .logclk(logclk[16]), .rst(rst), .cannons_on(cannons_on),
                    .bullet_pos_x(bullet_pos_x[i][j]), .bullet_pos_y(bullet_pos_y[i][j]));
                assign all_bullet_pos_x[11*`BULLETS_PER_CANNON*i+11*j +: 11] = bullet_pos_x[i][j];
                assign all_bullet_pos_y[10*`BULLETS_PER_CANNON*i+10*j +: 10] = bullet_pos_y[i][j];
            end
        end
    endgenerate

// ----------------------------------------------------------------------------------------------------------    
// Generating enemies 
// ----------------------------------------------------------------------------------------------------------    
    wire [10:0] enemy_pos_x [`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    wire [9:0] enemy_pos_y [`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    
    wire [11*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_x;
    wire [10*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_y;
    
    wire [`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] killed;
    
    generate
        genvar k; genvar l;
        for (k = 0; k < `CANNONS_NUM; k = k + 1) begin
            for (l = 0; l < `ENEMIES_PER_CANNON; l = l + 1) begin
                enemy #(.TOWARDS_CANNON(k), .ENEMY_NUM(l)) enemy ( // TODO - check if 11*`BULLETS_PER_CANNON*k +: 11*`BULLETS_PER_CANNON returns values in the correct range
                    .logclk(logclk[16]), .rst(rst),
                    .line_bullet_pos_x(all_bullet_pos_x[11*`BULLETS_PER_CANNON*k +: 11*`BULLETS_PER_CANNON]),
                    .enemy_pos_x(enemy_pos_x[k][l]), .enemy_pos_y(enemy_pos_y[k][l]),
                    .killed(killed[`ENEMIES_PER_CANNON*k + l]));
                assign all_enemy_pos_x[11*`ENEMIES_PER_CANNON*k+11*l +: 11] = enemy_pos_x[k][l];
                assign all_enemy_pos_y[10*`ENEMIES_PER_CANNON*k+10*l +: 10] = enemy_pos_y[k][l];
            end
        end
    endgenerate
    
// ----------------------------------------------------------------------------------------------------------    
// Instanciating Drawcon 
// ----------------------------------------------------------------------------------------------------------    
    drawcon drawcon(.block_pos_x(block_pos_x), .block_pos_y(block_pos_y),
                    .all_bullet_pos_x(all_bullet_pos_x), .all_bullet_pos_y(all_bullet_pos_y),
                    .all_enemy_pos_x(all_enemy_pos_x), .all_enemy_pos_y(all_enemy_pos_y),
                    .killed(killed),
                    .draw_x(curr_x), .draw_y(curr_y),
                    .r(red), .g(green), .b(blue)); 
endmodule