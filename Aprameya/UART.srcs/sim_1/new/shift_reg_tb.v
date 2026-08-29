`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 21:06:56
// Design Name: 
// Module Name: shift_reg_tb
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


module shift_reg_tb;
    reg uart_clk;
    reg rst;
    reg rx_out;
    reg shift_en;
    wire [7:0] rx_byte;
    wire byte_ready;
    
    shift_reg dut(
        .uart_clk(uart_clk),
        .rst(rst),
        .rx_out(rx_out),
        .shift_en(shift_en),
        .rx_byte(rx_byte),
        .byte_ready(byte_ready)
        );
    always #10 uart_clk = ~uart_clk;    
    
    initial
    begin
        rst = 0;
        uart_clk = 0;
        #20;
        rst = 1;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #20;
        rx_out = 1'b1;
        shift_en = 1;
        #20;
        rx_out = 1'b0;
        shift_en = 1;
        #40;
        $finish;
    end    
endmodule
