`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2026 15:29:23
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


module SSAC_TX_top(
    input uart_tx_clk, rst,
    input [7:0] tx_in,
    input fifo_wr_en,
    output tx_out
    
    );
    
    wire baud_tickx16_tx;
    wire tx_receive;
    wire tx_fifo_empty;
    wire shift_out;
    wire shift_receive;
    wire shift_full;
    wire [7:0] tx_fifo_out;

    tx_fifo tx_gate(
        .clk(uart_tx_clk),
        .rst(rst),
        .rd_en(shift_receive),
        .wr_en(fifo_wr_en),
        .data_in(tx_in),
        .empty(tx_fifo_empty),
        .fifo_data(tx_fifo_out)
        );
    
    tx_baud_gen tx_ticks(
        .uart_clk(uart_tx_clk),
        .rst(rst),
        .baud_tickx16(baud_tickx16_tx)
        );
        
    tx_uart tx_send(
        .uart_clk(uart_tx_clk),
        .rst(rst),
        .baud_tickx16(baud_tickx16_tx),
        .shift_full(shift_full),
        .tx_bit(shift_out),
        .tx_out(tx_out),
        .tx_receive(tx_receive)
        );
        
    tx_shift_reg tx_shift(
        .uart_clk(uart_tx_clk),
        .fifo_empty(tx_fifo_empty),
        .rst(rst),
        .tx_receive(tx_receive),
        .fifo_data(tx_fifo_out),
        .shift_receive(shift_receive),    
        .shift_full(shift_full),    
        .shift_out(shift_out)
        );
        
endmodule
