`timescale 1ns / 1ps

module multidigit(
    input clk, input rst,
    input [4:0] dig7, input [4:0] dig6, input [4:0] dig5,
    input [4:0] dig4, input [3:0] dig3, input [3:0] dig2,
    input [3:0] dig1, input [3:0] dig0,
    output a, output b, output c,
    output d, output e, output f,
    output g, output reg [7:0] an
    );
    
    reg [18:0] position;
    reg [4:0] curr_dig;
    wire [4:0] digit = curr_dig;
    
    sevenseg svnsg (.num(digit), .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g));
    
    always @ (posedge clk) begin
        if (!rst) 
            position <= 19'd0;
        else
            position <= position + 1'b1;
    end
    
    always @ (position[16]) begin
        case(position[18:16])
            3'd0 : begin
                an = 8'b11111110;
                curr_dig = {1'b0, dig0};
            end
            3'd1 : begin
                an = 8'b11111101;
                curr_dig = {1'b0, dig1};
            end
            3'd2 : begin 
                an = 8'b11111011;
                curr_dig = {1'b0, dig2};
            end
            3'd3 : begin
                an = 8'b11110111;
                curr_dig = {1'b0, dig3};
            end
            3'd4 : begin
                an = 8'b11101111;
                curr_dig = dig4;
            end
            3'd5 : begin
                an = 8'b11011111;
                curr_dig = dig5;
            end
            3'd6 : begin
                an = 8'b10111111;
                curr_dig = dig6;
            end
            3'd7 : begin
                an = 8'b01111111;
                curr_dig = dig7;
            end
            default: begin
                an = 8'b11111111;
                curr_dig = 5'b00000;
            end
        endcase
    end
    
endmodule
