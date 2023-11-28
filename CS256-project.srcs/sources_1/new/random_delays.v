`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 09:18:41 PM
// Design Name: 
// Module Name: random_delays
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


module random_delays(
    input clk, input rst, input btn_c,
    output reg [`CANNONS_NUM*`ENEMIES_PER_CANNON*`ENEMY_DELAY_SIZE-1:0] enemy_rnd
    );
    wire [`ENEMY_DELAY_SIZE-1:0] rnd;
    
    prng prng(.clk(clk), .rst(rst), .rnd(rnd));
   
    reg [`LOG_ENEMY_DELAY_SIZE-1:0] counter;
    
    always @ (posedge clk) begin
        if (!rst || btn_c) begin
            counter <= 1'b0;
            enemy_rnd <= 1'b0;
        end else begin
            counter <= counter >= `CANNONS_NUM*`ENEMIES_PER_CANNON ? 1'b0 : counter + 1'b1;
            enemy_rnd[`ENEMY_DELAY_SIZE*counter +: `ENEMY_DELAY_SIZE] <= 
                enemy_rnd[`ENEMY_DELAY_SIZE*counter +: `ENEMY_DELAY_SIZE] == `ENEMY_DELAY_SIZE'd0
                ? rnd 
                : enemy_rnd[`ENEMY_DELAY_SIZE*counter +: `ENEMY_DELAY_SIZE];
        end
    end
endmodule
