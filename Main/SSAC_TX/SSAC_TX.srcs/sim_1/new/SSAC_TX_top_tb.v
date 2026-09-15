`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2026 15:32:59
// Design Name: 
// Module Name: SSAC_top_tb
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


module SSAC_TX_top_tb;
    reg uart_tx_clk;
    reg rst;
    reg [7:0] tx_in;
    reg fifo_wr_en;
    wire tx_out;
    
    SSAC_TX_top top (
        .uart_tx_clk(uart_tx_clk),
        .rst(rst),
        .tx_in(tx_in),
        .fifo_wr_en(fifo_wr_en),
        .tx_out(tx_out)
        );
    
    always #10 uart_tx_clk = ~uart_tx_clk;
    
    initial
    begin
        uart_tx_clk = 1'b0;
        rst = 0;
        fifo_wr_en = 1'b0;
        #20;
        rst = 1'b1;
        
        // PACKET:1
        
        #20 fifo_wr_en = 1'b1;
            tx_in = 8'hAA;
        #20 tx_in = 8'h02;
        #20 tx_in = 8'h05;
        #20 tx_in = 8'hCA;
        #20 tx_in = 8'hCF;
        #20 tx_in = 8'hFF;
        
        // RANDOM BYTES:
        
//        #20 tx_in = 8'h07;
//        #20 tx_in = 8'h08;
        
        #20 fifo_wr_en = 1'b0;
    end
endmodule
