`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.08.2026 19:02:57
// Design Name: 
// Module Name: mem_buff
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


module mem_buff_rx(
    input sys_clk, rst,
    input rd_en,
    input wr_en,
    input [7:0] wr_data,
    output reg [7:0] rd_out,
    output empty, full
    );
    
    reg [5:0] wr_ptr, rd_ptr;
    reg [7:0] mem [0:63];
    
    integer i;
    
    always @ (posedge sys_clk)
    begin
        if(!rst)
        begin
            wr_ptr <= 6'b0;
            rd_ptr <= 6'b0;
            rd_out <= 8'b0;
            for(i = 0; i < 64; i = i+1'b1)
                mem[i] <= 8'b0; 
        end
        
        else
        begin
            
            if(wr_en && !full)
            begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end
                
            if(rd_en && !empty)
            begin
                rd_out <= mem[rd_ptr];
                mem[rd_ptr] <= 0;
                rd_ptr <= rd_ptr + 1'b1;        
            end
        end
    end
    
    assign empty = (rd_ptr == wr_ptr) ? 1'b1 : 1'b0;
    assign full = (wr_ptr == rd_ptr - 1'b1)? 1'b1 : 1'b0;         
endmodule
