`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2026 20:19:11
// Design Name: 
// Module Name: baud_gen_tb
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


module baud_gen_tb;
    reg uart_clk;
    reg rst;
    wire baud_tickx16;

    baud_gen dut(
        .uart_clk(uart_clk),
        .rst(rst),
        .baud_tickx16(baud_tickx16)
        );
    
    always #10 uart_clk = ~uart_clk;
    
    initial
    begin
        uart_clk = 0;
        rst = 0;        
        #20;
        rst = 1;
//        #2000;
//        $finish;
    end    
    
endmodule
