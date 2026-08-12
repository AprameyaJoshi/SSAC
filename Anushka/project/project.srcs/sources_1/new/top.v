`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 19:46:23
// Design Name: 
// Module Name: top
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


module top(
input clk,rst,rd_en,wr_en,
input[7:0]data_in,
output wire full,
output wire [7:0] fifo_data,

output wire pkt_valid,pkt_err,
output wire [7:0]chk_sum,
output wire [7:0]pkt_len,
output wire pkt_data_full
);

rx_fifo inst0(
            .clk(clk),
            .rst(rst),
            .rd_en(rd_en),
            .wr_en(wr_en),
            .data_in(data_in),
            .full(full),
            .empty(fifo_empty),
            .fifo_data(fifo_data)
            );

fsm inst1(
        .clk(clk),
        .rst(rst),
        .fifo_data(fifo_data),
        .fifo_empty(fifo_empty),
        .rd_en(rd_en),
        .pkt_valid(pkt_valid),
        .pkt_err(pkt_err),
        .chk_sum(chk_sum),
        .pkt_len(pkt_len),
        .pkt_data_full(pkt_data_full)
        );
        
endmodule
