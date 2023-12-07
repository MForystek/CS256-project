`timescale 1ns / 1ps

module random_delays_tb;
    reg clk;
    reg rst;
    reg btn_c;
    
    wire [`CANNONS_NUM*`ENEMIES_PER_CANNON*`ENEMY_DELAY_SIZE-1:0] enemy_rnd;
    
    random_delays uut (.clk(clk), .rst(rst), .btn_c(btn_c), .enemy_rnd(enemy_rnd));
    
    initial begin
        clk = 0;
    forever
        #1 clk = ~clk;
    end
    
    initial begin    
        rst = 1;
        btn_c = 0;
        #5;
        rst = 0;
        #5;
        rst = 1;
    end
    
endmodule
