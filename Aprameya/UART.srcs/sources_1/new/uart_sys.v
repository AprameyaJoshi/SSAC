`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 21:51:09
// Design Name: 
// Module Name: uart_sys
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

// Bit period = 8640ns;
module uart_sys(
    input uart_clk, rst,
    input rx_in,
    output byte_valid,
    output [7:0] rx_byte,
    output byte_ready,
    output framing_err
    );
    
    wire baud_tickx16;
    wire shift_en;
    wire rx_out;
    
    baud_gen ticks (
        .uart_clk(uart_clk),
        .rst(rst),
        .baud_tickx16(baud_tickx16)
        );
        
    uart_rx sample (
        .uart_clk(uart_clk),
        .rst(rst),
        .baud_tickx16(baud_tickx16),
        .rx_in(rx_in),
        .rx_out(rx_out),
        .shift_en(shift_en),
        .byte_valid(byte_valid),
        .framing_err(framing_err)
        );
        
    shift_reg shift (
        .uart_clk(uart_clk),
        .byte_valid(byte_valid),
        .rst(rst),
        .rx_out(rx_out),
        .shift_en(shift_en),
        .rx_byte(rx_byte),
        .byte_ready(byte_ready)
        );
endmodule
