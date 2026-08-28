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
    input uart_clk,rst, byte_valid,
    input rx_out,shift_en,
    output reg [7:0] rx_byte,
    output reg byte_ready
    );
    
    reg [2:0] i;
            
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            rx_byte <= 8'b0;
            byte_ready <= 1'b0;
            i <= 3'b0; 
        end
        else
        begin
            byte_ready <= 1'b0;
            if(shift_en == 1)
                if(i < 7)
                begin
                    rx_byte[i] <= rx_out;
                    i <= i+1'b1;
                end
                else
                begin
                    rx_byte[i] <= rx_out;
                    i <= 1'b0;
                end
            else if (byte_valid == 1)
                 byte_ready <= 1'b1;
        end               
    end
endmodule
