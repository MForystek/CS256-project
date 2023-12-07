`timescale 1ns / 1ps

module prng_tb;
    reg clk;
    reg rst;
    
    wire [`ENEMY_DELAY_SIZE-1:0] rnd;
    
    prng uut (.clk(clk), .rst(rst), .rnd(rnd));
    
    initial begin
        clk = 0;
    forever
        #50 clk = ~clk;
    end
    
    initial begin    
        rst = 1;
        #100;
        rst = 0;
        #200;
        rst = 1;    
    end
    
    initial begin
        $display("clock rnd");
        $monitor("%b,%b", clk, rnd);
    end  

endmodule