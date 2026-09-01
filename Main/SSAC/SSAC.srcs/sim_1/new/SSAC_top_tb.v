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
    reg rx_in;
    reg rd_en;
    wire [7:0] mem_byte_out;
    wire mem_empty;
    wire mem_full;
    
    SSAC_top top (
        .uart_clk(uart_clk),
        .sys_clk(sys_clk),
        .rst(rst),
        .rx_in(rx_in),
        .rd_en(rd_en),
        .mem_byte_out(mem_byte_out),
        .mem_empty(mem_empty),
        .mem_full(mem_full)
        );
    
    always #10 uart_clk = ~uart_clk;
    
    always #5 sys_clk = ~sys_clk;
    
    initial
    begin
        uart_clk = 0;
        sys_clk = 0;
        rst = 0;
        rx_in = 1;
        rd_en = 0;
        #20;
        rst = 1;
        rd_en = 1;
        
        // PACKET: 1
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //HEADER byte: 10101010
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1; // STOP BIT
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //LEN byte: 00000010
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 1; //STOP BIT
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //DATA byte 1: 11001100
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1; // VALID STOP BIT
        
        #8640;rx_in = 0; //START BIT
        #8640;rx_in = 0; //DATA byte 2: 1000000
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1; // VALID STOP BIT
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //CHKSUM byte: 01001100
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1; // VALID STOP BIT
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 1; //END byte: 11111111
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1;
        #8640;rx_in = 1; // VALID STOP BIT
        
        // PACKET: 2
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //HEADER byte: 10101010
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 1;
        #8640;rx_in = 1; // STOP BIT
        
        #8640;rx_in = 0; // START BIT
        #8640;rx_in = 0; //LEN byte: 00000010
        #8640;rx_in = 1;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 0;
        #8640;rx_in = 1; //STOP BIT
        
//        #8640;rx_in = 0; // START BIT
//        #8640;rx_in = 0; //DATA byte: 11001100
//        #8640;rx_in = 0;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1; // VALID STOP BIT
        
//        #8640;rx_in = 0; //START BIT
//        #8640;rx_in = 0; //DATA byte: 1000000
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1; // VALID STOP BIT
        
//        #8640;rx_in = 0; // START BIT
//        #8640;rx_in = 0; //CHK_SUM byte: 01001100
//        #8640;rx_in = 0;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 0;
//        #8640;rx_in = 0;
//        #8640;rx_in = 1;
//        #8640;rx_in = 0;
//        #8640;rx_in = 1; // VALID STOP BIT
        
//        #8640;rx_in = 0; // START BIT
//        #8640;rx_in = 1; //END byte: 11111111
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1;
//        #8640;rx_in = 1; // VALID STOP BIT
        
//        #8640;$finish;
    end
endmodule
