`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 09:24:53
// Design Name: 
// Module Name: rx_fifo
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


module rx_fifo(
input clk,rst,rd_en,wr_en,
input[7:0]data_in,
output wire full,empty,
output [7:0]fifo_data
);

reg [7:0]mem[0:15];
reg [3:0]rd_ptr=0,wr_ptr=0,cnt=0;

always @(posedge clk)
begin
    if(!rst)
    begin
        rd_ptr<=0;
        wr_ptr<=0;
        cnt<=0;
    end
    else
    begin
        if (wr_en && !full)
        begin
            mem[wr_ptr]<=data_in;
            wr_ptr<=wr_ptr+1'b1;
            cnt<=cnt+1'b1;
        end
        if (rd_en && !empty )
        begin
            rd_ptr<=rd_ptr+1'b1;
            cnt<=cnt-1'b1;
        end
    end
end
assign empty=(cnt==0)?1'b1:1'b0;
assign full=(cnt==5'd16)?1'b1:1'b0;
assign fifo_data=mem[rd_ptr];  
endmodule
