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
 
 // FRAME
`define FRAME_WIDTH 11'd10
`define FRAME_HEIGHT 10'd10

// MOVING BLOCK
`define BLOCK_WIDTH 11'd32
`define BLOCK_HEIGHT 10'd32
`define BLOCK_SPEED_X 11'd4
`define BLOCK_SPEED_Y 10'd4

// CANNONS
`define CANNONS_NUM 4
`define CANNON_OFFSET_X 11'd100
`define CANNON_WIDTH 11'd100
`define CANNON_OFFSET_Y 10'd100
`define CANNON_HEIGHT 10'd50
`define CANNON_DISTANCE 10'd133

// BULLETS
`define BULLETS_PER_CANNON 8
`define BULLET_WIDTH 11'd50
`define BULLET_HEIGHT 10'd18
`define BULLET_SPEED 4'd12

// ENEMIES
`define ENEMIES_PER_CANNON 6
`define ENEMY_WIDTH 11'd20
`define ENEMY_HEIGHT 10'd50
`define ENEMY_SPEED 4'd3