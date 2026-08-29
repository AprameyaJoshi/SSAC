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


module rx_fifo_tb;
reg clk,rst,rd_en,wr_en;
reg[7:0]data_in;
wire full,empty;
wire[7:0] fifo_data;

rx_fifo dut(
            .clk(clk),
            .rst(rst),
            .rd_en(rd_en),
            .wr_en(wr_en),
            .data_in(data_in),
            .full(full),
            .empty(empty),
            .fifo_data(fifo_data)
            );

always #5 clk=~clk;
initial begin
clk=0;rst=0;
#10 rst=1;
wr_en=1;
for(integer i=0;i<16;i=i+1)
begin
    #10;
    data_in=$random;   
end
#10 rd_en=1; wr_en=0;
#300 $finish;
end
endmodule
