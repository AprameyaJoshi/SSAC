`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2026 21:53:06
// Design Name: 
// Module Name: checksum
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


module checksum(
input clk,
input [7:0]chk_sum,
output reg [7:0]pkt_data[0:15],
output reg [7:0]pkt_len,
output reg [7:0]chk_ans
);
reg [3:0] i=0;
always @(posedge clk)
begin
       while(i<pkt_len)
       begin
            chk_ans<=chk_ans+pkt_data[i];        
       end
       i<=0;
end
endmodule
