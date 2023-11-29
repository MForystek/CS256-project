`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 12:12:37 AM
// Design Name: 
// Module Name: bullet
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

module bullet #(parameter FROM_CANNON = 0, parameter BULLET_NUM = 0)(
    input logclk, input rst, input btn_c, input [`CANNONS_NUM-1:0] cannons_on,
    input [11*`ENEMIES_PER_CANNON-1:0] line_enemy_pos_x,
    input global_gameover,
    output reg [10:0] bullet_pos_x, output [9:0] bullet_pos_y
    );
    
    localparam [`DELAY_SIZE-1:0] DELAY = `DELAY_SIZE'd120 / `BULLETS_PER_CANNON * BULLET_NUM;
    
    reg hit_from_left[`ENEMIES_PER_CANNON-1:0];
    reg hit_from_right[`ENEMIES_PER_CANNON-1:0];
    reg [`ENEMIES_PER_CANNON-1:0] hit_enemy;
       
    integer i;
    always @ (posedge logclk) begin        
        for (i = 0; i < `ENEMIES_PER_CANNON; i = i + 1) begin
            hit_from_left[i] <= bullet_pos_x <= line_enemy_pos_x[11*i +: 11] + `ENEMY_WIDTH 
                         && bullet_pos_x + `BULLET_WIDTH >= line_enemy_pos_x[11*i +: 11] + `ENEMY_WIDTH;
            hit_from_right[i] <= bullet_pos_x <= line_enemy_pos_x[11*i +: 11] 
                          && bullet_pos_x + `BULLET_WIDTH >= line_enemy_pos_x[11*i +: 11];
        
            if (!global_gameover && bullet_pos_x != `BULLET_STARTING_POS_X
                    && line_enemy_pos_x[11*i +: 11] != `ENEMY_STARTING_POS_X
                    && (hit_from_left[i] || hit_from_right[i]))
                hit_enemy[i] <= 1'b1;
            else
                hit_enemy[i] <= 1'b0;
        end
    end
    
    
    reg [`DELAY_SIZE-1:0] bullet_timer;
    assign reset_timer = !rst || !cannons_on[FROM_CANNON] || hit_enemy;
    assign can_count_up = bullet_timer < DELAY && bullet_pos_x == `BULLET_STARTING_POS_X;
    
    always @ (posedge logclk) begin        
        if (reset_timer)
            bullet_timer <= `DELAY_SIZE'd0;
        else if (can_count_up)
            bullet_timer <= bullet_timer + 1'b1;
    end
    
    
    assign reached_right_frame = bullet_pos_x >= `WIDTH - `FRAME_WIDTH - 11'd1;
    assign not_ready_to_be_fired = !cannons_on[FROM_CANNON]
                                || (cannons_on[FROM_CANNON] && bullet_timer < DELAY);
    
    always @ (posedge logclk) begin
        if (!rst || btn_c || global_gameover || hit_enemy || reached_right_frame || (bullet_pos_x == `BULLET_STARTING_POS_X && not_ready_to_be_fired)) begin
            bullet_pos_x <= `BULLET_STARTING_POS_X;
        end else
            bullet_pos_x <= bullet_pos_x + `BULLET_SPEED;
    end
    
    localparam [9:0] ALIGN_TO_CANNON = 10'd10;
    
    assign bullet_pos_y = `CANNON_OFFSET_Y + `CANNON_HEIGHT*FROM_CANNON + `CANNON_DISTANCE*FROM_CANNON + (`CANNON_HEIGHT - `BULLET_HEIGHT) / 2 - ALIGN_TO_CANNON;

endmodule
