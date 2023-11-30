`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 04:07:37 PM
// Design Name: 
// Module Name: constants
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
`define WIDTH 11'd1279
`define HEIGHT 10'd799

`define RNG_SIZE 16
`define LOG_RNG_SIZE 5

`define ENEMY_DELAY_SIZE 64
`define LOG_ENEMY_DELAY_SIZE 6
`define BULLET_DELAY_SIZE 15
`define LOG_BULLET_DELAY_SIZE 4
 
`define MASK 12'hFFF
 
 // FRAME
`define FRAME_WIDTH 11'd20
`define FRAME_HEIGHT 10'd20

// MOVING BLOCK
`define BLOCK_WIDTH 11'd32
`define BLOCK_HEIGHT 10'd32
`define BLOCK_SPEED_X 11'd4
`define BLOCK_SPEED_Y 10'd4

// CANNONS
`define CANNONS_NUM 4
`define CANNON_OFFSET_X 11'd150
`define CANNON_WIDTH 11'd92
`define CANNON_OFFSET_Y 10'd100
`define CANNON_HEIGHT 10'd65
`define CANNON_DISTANCE 10'd130

// BULLETS
`define BULLETS_PER_CANNON 4
`define BULLET_WIDTH 11'd22
`define BULLET_HEIGHT 10'd22
`define BULLET_SPEED 4'd6
`define BULLET_STARTING_POS_X `CANNON_OFFSET_X+`CANNON_WIDTH-`BULLET_WIDTH
`define ADDITIONAL_BULLETS 10

// ENEMIES
`define ENEMIES_PER_CANNON 16
`define ENEMY_WIDTH 11'd50
`define ENEMY_HEIGHT 10'd61
`define ENEMY_SPEED 4'd2
`define ENEMY_STARTING_POS_X `WIDTH-11'd1