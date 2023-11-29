`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 01:16:08 AM
// Design Name: 
// Module Name: enemy
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

// TO TEST - Enemies are killed when their enemy_pos_x + enemy_width intersects with the bullet_pos_x + bullet_width
// TODO - Game ends when the enemy_pos_x + enemt_width intersects with the cannon_pos_x + cannon_width
// TODO - Figure out the way for random timer for group of enemies
// TODO - Display on the FPGA digits display the number of enemies and bullets left
module enemy #(
        parameter TOWARDS_CANNON = 0, 
        parameter ENEMY_NUM = 0
    )(
    input logclk, input rst, input btn_c,
    input [11*`BULLETS_PER_CANNON-1:0] line_bullet_pos_x,
    input global_gameover,
    output reg [10:0] enemy_pos_x, output reg [9:0] enemy_pos_y,
    output reg killed, output gameover
    );
    
    localparam [`DELAY_SIZE:0] DELAY = `DELAY_SIZE'd504 / `ENEMIES_PER_CANNON * ENEMY_NUM;

    
    reg hit_from_left[`BULLETS_PER_CANNON-1:0];
    reg hit_from_right[`BULLETS_PER_CANNON-1:0];
    
    integer i;
    always @ (posedge logclk) begin
        if (!rst || btn_c)
            killed <= 1'b0;
        else begin
            for (i = 0; i < `BULLETS_PER_CANNON; i = i + 1) begin
                hit_from_left[i] <= enemy_pos_x <= line_bullet_pos_x[11*i +: 11] + `BULLET_WIDTH 
                             && enemy_pos_x + `ENEMY_WIDTH >= line_bullet_pos_x[11*i +: 11] + `BULLET_WIDTH;
                hit_from_right[i] <= enemy_pos_x <= line_bullet_pos_x[11*i +: 11] 
                              && enemy_pos_x + `ENEMY_WIDTH >= line_bullet_pos_x[11*i +: 11];
                
                if (!global_gameover && enemy_pos_x != `ENEMY_STARTING_POS_X
                        && line_bullet_pos_x[11*i +: 11] != `BULLET_STARTING_POS_X
                        && (hit_from_left[i] || hit_from_right[i]))
                    killed <= 1'b1;
            end
        end
    end
    
    
    reg [`DELAY_SIZE-1:0] enemy_timer;
    assign can_count_up = enemy_timer < DELAY && enemy_pos_x == `ENEMY_STARTING_POS_X;
    
    always @ (posedge logclk) begin
        if (!rst || btn_c)
            enemy_timer <= `DELAY_SIZE'd0;
        else if (can_count_up)
            enemy_timer <= enemy_timer + 1'b1;
    end
    
    
    assign reached_left_frame = enemy_pos_x + `ENEMY_WIDTH <= `FRAME_WIDTH;
    
    assign gameover = enemy_pos_x <= `CANNON_OFFSET_X ? 1'b1 : 1'b0;
    
    always @ (posedge logclk) begin
        if (killed) begin
            enemy_pos_x <= `WIDTH;
            enemy_pos_y <= `HEIGHT;
        end else begin 
            if (!rst || btn_c || reached_left_frame || (enemy_pos_x == `ENEMY_STARTING_POS_X && enemy_timer < DELAY))
                enemy_pos_x <= `ENEMY_STARTING_POS_X;
            else if (!gameover)
                enemy_pos_x <= enemy_pos_x - `ENEMY_SPEED;
            
            enemy_pos_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*TOWARDS_CANNON + `CANNON_DISTANCE*TOWARDS_CANNON + (`CANNON_HEIGHT - `ENEMY_HEIGHT) / 2;
        end
    end
endmodule
