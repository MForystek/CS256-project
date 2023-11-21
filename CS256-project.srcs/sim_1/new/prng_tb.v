`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 04:45:14 PM
// Design Name: 
// Module Name: prng_tb
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


module prng_tb;

    reg clk;
    reg rst;
    
    wire [`DELAY_SIZE-1:0] rnd;
    
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