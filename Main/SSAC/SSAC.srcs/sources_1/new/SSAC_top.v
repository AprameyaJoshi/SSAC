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


module SSAC_top(
    input uart_clk, sys_clk, rst,
    input rx_in,
    output [7:0] cdc_byte_out,
    output cdc_pkt_valid 
    
    );
    
    wire baud_tickx16;
    wire shift_en;
    wire rx_out;
    wire uart_byte_ready;
    wire [7:0]uart_byte_out;
    wire byte_valid;
    wire fsm_read_en;
    wire rx_fifo_empty;
    wire [7:0] rx_fifo_out;
    wire fsm_pkt_valid;
    wire [7:0]fsm_byte_out;
    
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
        .byte_valid(byte_valid)
        );
        
    shift_reg shift (
        .uart_clk(uart_clk),
        .byte_valid(byte_valid),
        .rst(rst),
        .rx_out(rx_out),
        .shift_en(shift_en),
        .rx_byte(uart_byte_out),
        .byte_ready(uart_byte_ready)
        );
        
    rx_fifo inst0(
        .clk(uart_clk),
        .rst(rst),
        .rd_en(fsm_read_en),
        .wr_en(uart_byte_ready),
        .data_in(uart_byte_out),
        .empty(rx_fifo_empty),
        .fifo_data(rx_fifo_out)
        );

    fsm inst1(
        .clk(uart_clk),
        .rst(rst),
        .fifo_data(rx_fifo_out),
        .fifo_empty(rx_fifo_empty),
        .rd_en(fsm_read_en),
        .pkt_valid(fsm_pkt_valid),
        .byte_out(fsm_byte_out)
        );
        
    cdc inst2(
        .wr_clk(uart_clk),
        .rd_clk(sys_clk),
        .rst_n(rst),
        .data_in(fsm_byte_out),
        .data_valid(fsm_pkt_valid),
        .data_out(cdc_byte_out),
        .data_out_valid(cdc_pkt_valid)
        );
  
endmodule
