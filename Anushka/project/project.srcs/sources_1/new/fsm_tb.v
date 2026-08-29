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
reg fifo_empty;
wire rd_en;
wire pkt_valid;
wire [7:0]chk_sum;
wire [7:0]pkt_len;
wire pkt_data_full;
wire [7:0]byte_out;
wire valid;

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
        
        );

always #10 clk=~clk;
initial begin
clk=0;rst=0;fifo_empty=1;
#20 rst=1;fifo_empty=0;
@(posedge clk)
begin
#20 fifo_data=8'h10;
 
#20 fifo_data=8'hAA;
#20 fifo_data=8'd3;
#20 fifo_data=8'h11;
#20 fifo_data=8'h99;
#20 fifo_data=8'h20;
#20 fifo_data=8'hCA;
#20 fifo_data=8'hFF;
 
#20 fifo_data=8'h26;
#20 fifo_data=8'h33;
 
#20 fifo_data=8'hAA;
#20 fifo_data=8'd15;
#20 fifo_data=8'h1;
#20 fifo_data=8'h2;
#20 fifo_data=8'h3;
#20 fifo_data=8'h4;
#20 fifo_data=8'h5;
#20 fifo_data=8'h6;
#20 fifo_data=8'h7;
#20 fifo_data=8'h8;
#20 fifo_data=8'h9;
#20 fifo_data=8'h10;
#20 fifo_data=8'h11;
#20 fifo_data=8'h12;
#20 fifo_data=8'h13;
#20 fifo_data=8'h14;
#20 fifo_data=8'h15;
#20 fifo_data=8'h9C;
#20 fifo_data=8'hFF;

//#20 fifo_data=8'hAA;
//#20 fifo_data=8'd1;
//#20 fifo_data=8'h11;
//#20 fifo_data=8'h11;
//#20 fifo_data=8'hFF;
 
#20 fifo_data=8'hAA;
#20 fifo_data=8'd5;
#20 fifo_data=8'hEE;
#20 fifo_data=8'h34;
#20 fifo_data=8'h21;
#20 fifo_data=8'h90;
#20 fifo_data=8'hAE;
#20 fifo_data=8'h81;
#20 fifo_data=8'hFF;
 
#20 fifo_data=8'h89;
#20 fifo_data=8'h12;
 
#20 fifo_data=8'hAA;
#20 fifo_data=8'd2;
#20 fifo_data=8'h18;
#20 fifo_data=8'h60;
#20 fifo_data=8'h78;
#20 fifo_data=8'hFF;

#500 $finish;
end
end
endmodule