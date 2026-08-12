`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 21:36:43
// Design Name: 
// Module Name: top_tb
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


module top_tb;
reg clk,rst,rd_en,wr_en;
reg[7:0]data_in;
wire full;
wire [7:0] fifo_data;
wire pkt_valid,pkt_err;
wire [7:0]chk_sum;
wire [7:0]pkt_len;
wire pkt_data_full;

top dut (   .clk(clk),
            .rst(rst),
            .rd_en(rd_en),
            .wr_en(wr_en),
            .data_in(data_in),
            .full(full),
            .fifo_data(fifo_data),
            .pkt_valid(pkt_valid),
            .pkt_err(pkt_err),
            .chk_sum(chk_sum),
            .pkt_len(pkt_len),
            .pkt_data_full(pkt_data_full)
            );

always #5 clk=~clk;            
initial begin
clk=0;rst=0;
#10 rst=1;wr_en=1;
#10 data_in=8'h10;
#10 data_in=8'hAA;
#10 data_in=8'd3;
#10 data_in=8'h11;
#10 data_in=8'h99;
#10 data_in=8'h20;
#10 data_in=8'hCA;
#10 data_in=8'hFF;
#10 data_in=8'h21;
#10 rd_en=1;
#200 $finish;
end
endmodule
