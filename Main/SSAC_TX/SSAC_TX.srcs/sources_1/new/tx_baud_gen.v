`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2026 19:41:04
// Design Name: 
// Module Name: baud_gen
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


module tx_baud_gen #(
    parameter clk_freq = 50_000_000,
    parameter baud_rate = 115200,
    parameter oversample = 16
    )(
    input uart_clk,
    input rst,
    output reg baud_tickx16    
    );
    
    reg [7:0] counter;
    localparam integer divisor = clk_freq/(baud_rate * oversample);
    
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            counter <= 8'b0;
            baud_tickx16 <= 1'b0;
        end
        
        else
        begin
            if(counter == (divisor - 1))
            begin
                counter <= 8'b0;
                baud_tickx16 <= 1'b1;
            end
        
            else
            begin
                counter <= counter + 1'b1;
                baud_tickx16 <= 1'b0;
            end
        end 
    end
endmodule
