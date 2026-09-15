`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.09.2026 19:22:14
// Design Name: 
// Module Name: SSAC_top
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


module SSAC_top(
    input uart_clk, sys_clk, rst,
    input [7:0] tx_byte,
    input tx_fifo_wr_en,
    input mem_rd_en,
    output [7:0] rx_mem_byte_out,
    output rx_mem_full, rx_mem_empty
    );
    
    wire tx_out;
    
    SSAC_TX_top transmit(
        .uart_tx_clk(uart_clk),
        .rst(rst),
        .tx_in(tx_byte),
        .fifo_wr_en(tx_fifo_wr_en),
        .tx_out(tx_out)
        );
        
    SSAC_RX_top receive(
        .uart_rx_clk(uart_clk),
        .sys_clk(sys_clk),
        .rst(rst),
        .rx_in(tx_out),
        .rd_en(mem_rd_en),
        .mem_byte_out(rx_mem_byte_out),
        .mem_full(rx_mem_full),
        .mem_empty(rx_mem_empty)
        );
endmodule
