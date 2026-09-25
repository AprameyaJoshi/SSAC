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


module SSAC_top_tb;
    reg uart_clk;
    reg sys_clk;
    reg rst;
    reg [7:0] tx_byte;
    reg tx_fifo_wr_en;
    reg mem_rd_en;
    wire [7:0] rx_mem_byte_out;
    wire rx_mem_empty;
    wire rx_mem_full;
    
    SSAC_top top (
        .uart_clk(uart_clk),
        .sys_clk(sys_clk),
        .rst(rst),
        .tx_byte(tx_byte),
        .tx_fifo_wr_en(tx_fifo_wr_en),
        .mem_rd_en(mem_rd_en),
        .rx_mem_byte_out(rx_mem_byte_out),
        .rx_mem_full(rx_mem_full),
        .rx_mem_empty(rx_mem_empty)
        );
    
    always #10 uart_clk = ~uart_clk;
    
    always #5 sys_clk = ~sys_clk;
    
    initial
    begin
        uart_clk = 1'b0;
        sys_clk = 1'b0;
        rst = 1'b0;
        mem_rd_en = 1'b0;
        tx_fifo_wr_en = 1'b0;
        #20;
        rst = 1'b1;
        mem_rd_en = 1'b1;
        // PACKET:1        
        #20 tx_fifo_wr_en = 1'b1;
            tx_byte = 8'hAA;    // HEADER BYTE
        #20 tx_byte = 8'h02;    // LENGTH BYTE
        #20 tx_byte = 8'h05;    // DATABYTES:
        #20 tx_byte = 8'hCA;
        #20 tx_byte = 8'hCF;    // CHECKSUM
        #20 tx_byte = 8'hFF;    // END BYTE
        
        // PACKET:2
        
        #20 tx_byte = 8'hAA;    // HEADER BYTE
        #20 tx_byte = 8'h05;    // LENGTH BYTE
        #20 tx_byte = 8'h00;    // DATA BYTES:
        #20 tx_byte = 8'h01;
        #20 tx_byte = 8'h02;
        #20 tx_byte = 8'h03;
        #20 tx_byte = 8'h04;
        #20 tx_byte = 8'h0A;    // CHECKSUM BYTE
        #20 tx_byte = 8'hff;
        
        // PACKET:3
        
        #20 tx_byte = 8'hAA;    // HEADER BYTE
        #20 tx_byte = 8'h02;    //LENGTH BYTE
        #20 tx_byte = 8'h08;    //DATA BYTES:
        #20 tx_byte = 8'h02;
        #20 tx_byte = 8'h0A;    //CHECKSUM BYTE
        #20 tx_byte = 8'hff;    // END BYTE
        
        #20 tx_fifo_wr_en = 1'b0;
    end
endmodule
