`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 14:27:55
// Design Name: 
// Module Name: uart_sys_tb
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


module uart_sys_tb;
    reg uart_clk;
    reg rst;
    reg rx_in;
    wire byte_valid;
    wire [7:0] rx_byte;
    wire byte_ready;
    
    uart_sys top (
        .uart_clk(uart_clk),
        .rst(rst),
        .rx_in(rx_in),
        .byte_valid(byte_valid),
        .rx_byte(rx_byte),
        .byte_ready(byte_ready)
        );
    
    always #10 uart_clk = ~uart_clk;
    
    initial
    begin
        uart_clk = 0;
        rst = 0;
        rx_in = 1;
        #20;
        rst = 1;
        #8640;
        rx_in = 0; // START BIT
        #8640;
        rx_in = 1; //byte: 01001101
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1; // STOP BIT
        #8640;
        rx_in = 0; // START BIT
        #8640;
        rx_in = 1; //byte: 01010101
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1;
        #8640;
        rx_in = 0;
        #8640;
        rx_in = 1; // STOP BIT
        #560;
        $finish;
    end
endmodule
