`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 14:18:15
// Design Name: 
// Module Name: fsm_tb
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
wire pkt_valid;
wire [7:0]chk_sum;
wire [7:0]pkt_len;
wire pkt_data_full;
wire [7:0]byte_out;
//wire busy;

fsm dut(
        .clk(clk),
        .rst(rst),
        .fifo_data(fifo_data),
        .fifo_empty(fifo_empty),
        .rd_en(rd_en),
        .pkt_valid(pkt_valid),
        .chk_sum(chk_sum),
        .pkt_len(pkt_len),
        .pkt_data_full(pkt_data_full),
        .byte_out(byte_out)
        //.busy(busy)
        );

always #5 clk=~clk;
initial begin
clk=0;rst=0;fifo_empty=1;rd_en=0;
#10 rst=1;rd_en=1;fifo_empty=0;
@(posedge clk)
begin
#10 fifo_data=8'h10;

#10 fifo_data=8'hAA;
#10 fifo_data=8'd3;
#10 fifo_data=8'h11;
#10 fifo_data=8'h99;
#10 fifo_data=8'h20;
#10 fifo_data=8'hCA;
#10 fifo_data=8'hFF;

#10 fifo_data=8'h26;
#10 fifo_data=8'h33;

#10 fifo_data=8'hAA;
#10 fifo_data=8'd4;
#10 fifo_data=8'h33;
#10 fifo_data=8'h16;
#10 fifo_data=8'hEA;
#10 fifo_data=8'h40;
#10 fifo_data=8'h73;
#10 fifo_data=8'hFF;

#10 fifo_data=8'hAA;
#10 fifo_data=8'd2;
#10 fifo_data=8'hEE;
#10 fifo_data=8'h34;
#10 fifo_data=8'h22;
#10 fifo_data=8'hFF;

#10 fifo_data=8'h89;
#10 fifo_data=8'h12;

#10 fifo_data=8'hAA;
#10 fifo_data=8'd2;
#10 fifo_data=8'h18;
#10 fifo_data=8'h60;
#10 fifo_data=8'h78;
#10 fifo_data=8'hFF;

#100 $finish;
end
end
endmodule