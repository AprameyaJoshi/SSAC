`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 14:18:15
// Design Name: 
// Module Name: rx_fifo_tb
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

module fsm_tb;
reg clk,rst;
reg [7:0]fifo_data;
reg fifo_empty,rd_en;
wire pkt_valid,pkt_err;
wire [7:0]chk_sum;
wire [7:0]pkt_len;
wire pkt_data_full;

fsm dut(
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

always #5 clk=~clk;
initial begin
clk=0;fifo_empty=1;rd_en=0;rst=0;
#10 rst=1;
#10 fifo_empty=0; rd_en=1;
#200 $finish;
end
endmodule