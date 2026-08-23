`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 21:06:18
// Design Name: 
// Module Name: shift_reg
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


module shift_reg(
    input uart_clk,rst,
    input rx_out,bit_valid,
    output reg [7:0] rx_byte,
    output reg byte_ready
    );
    
    integer i = 1'b0;
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            rx_byte <= 8'b0;
            byte_ready = 1'b0;
        end
        else
        begin
            if(bit_valid == 1)
            begin
                if(i <= 7)
                begin
                    rx_byte[i] <= rx_out;
                    i <= i+1'b1;
                end
                if(i == 7)
                begin
                    byte_ready = 1'b1;
                end
                if(i == 8)
                begin
                    i <= 1'b0;
                    rx_byte = 8'b0;
                    byte_ready = 1'b0;
                end
            end
            else
                byte_ready = 1'b0;   
        end
    end
endmodule
