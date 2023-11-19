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


// TO TEST - Enemies go back to the start point when their enemy_pos_x + enemy_width intersects with the bullet_pos_x + bullet_width
// TODO - Bullets go back to the start point when their bullet_pos_x + bullet_width intersects with the enemy_pos_x + enemy_width
// TODO - Game ends when the enemy_pos_x + enemt_width intersects with the cannon_pos_x + cannon_width
// TODO - Figure out the way for random timer for group of enemies
// TODO - Display on the FPGA digits display the number of enemies and bullets left
module enemy #(parameter TOWARDS_CANNON = 0, parameter ENEMY_NUM = 0)(
    input logclk, input rst, input [11*`BULLETS_PER_CANNON-1:0] line_bullet_pos_x,
    output reg [10:0] enemy_pos_x, output reg [9:0] enemy_pos_y,
    output killed
    );
    
    localparam [5:0] DELAY = 6'd60 / `ENEMIES_PER_CANNON * ENEMY_NUM;
    reg [5:0] enemy_timer;
    reg hit_by_bullet;
    
    integer i;
    always @ (posedge logclk) begin
        if (!rst)
            hit_by_bullet <= 1'b0;
        else begin
            for (i = 0; i < `BULLETS_PER_CANNON; i = i + 1) begin
                if ((enemy_pos_x <= line_bullet_pos_x[11*i +: 11] && enemy_pos_x >= line_bullet_pos_x[11*i +: 11] - `BULLET_WIDTH) 
                 || (enemy_pos_x + `ENEMY_WIDTH >= line_bullet_pos_x[11*i +: 11] - `BULLET_WIDTH && enemy_pos_x + `ENEMY_WIDTH <= line_bullet_pos_x[11*i +: 11]))
                 hit_by_bullet <= 1'b1;
            end
        end
    end
    
    // TO TEST - do we need to subtracty 11'd1 from WIDTH - ENEMY_WIDTH or it is okay by itself
    always @ (posedge logclk) begin
        if (!rst)
            enemy_timer <= 6'd0;
        else if (enemy_timer < DELAY && enemy_pos_x == `WIDTH - `ENEMY_WIDTH)
            enemy_timer <= enemy_timer + 1'b1;
        
        if (!rst || enemy_pos_x <= `WIDTH - `ENEMY_WIDTH || (enemy_pos_x == `WIDTH - `ENEMY_WIDTH && enemy_timer < DELAY))
            enemy_pos_x <= `WIDTH - `ENEMY_WIDTH;
        else
            enemy_pos_x <= enemy_pos_x - `ENEMY_SPEED;
        
        enemy_pos_y <= `CANNON_OFFSET_Y + `CANNON_HEIGHT*TOWARDS_CANNON + `CANNON_DISTANCE*TOWARDS_CANNON + (`CANNON_HEIGHT - `ENEMY_HEIGHT) / 2;    
            
        if (hit_by_bullet) begin
            enemy_pos_x <= `WIDTH;
            enemy_pos_y <= `HEIGHT;
        end
    end
    
    assign killed = enemy_pos_x == `WIDTH && enemy_pos_y == `HEIGHT ? 1'b1 : 1'b0;


endmodule
