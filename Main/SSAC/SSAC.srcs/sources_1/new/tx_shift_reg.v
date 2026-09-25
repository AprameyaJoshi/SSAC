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


module tx_shift_reg(
    input uart_clk,rst,
    input fifo_empty,
    input tx_receive,
    input [7:0] fifo_data,
    output reg shift_out, shift_receive, shift_full
    );
    
    reg [7:0] shift_reg1; 
    reg [2:0] i;
                
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            shift_full <= 1'b0;
            shift_receive <= 1'b0;
            shift_reg1 <= 8'b0;
            shift_out <= 1'b0;
            i <= 3'b0; 
        end
        
        else
        begin
            shift_receive <= 1'b0;
            
            if(!shift_full && !fifo_empty)
            begin
                shift_receive <= 1'b1;
                shift_full <= 1'b1;
            end            
            
            if(tx_receive)
            begin
                if(i < 3'd7)
                begin
                    shift_out <= fifo_data[i];
                    i <= i+1'b1;
                end
                if(i == 7)
                begin
                    shift_out <= fifo_data[i];
                    i <= i+1'b1;
                    shift_full <= 1'b0;
                end
            end 
        end               
    end
endmodule
