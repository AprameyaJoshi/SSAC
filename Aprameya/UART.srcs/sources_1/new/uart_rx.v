`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2026 21:13:57
// Design Name: 
// Module Name: uart_rx
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

//BIT period = 8680ns
module uart_rx(
    input baud_tickx16,
    input uart_clk, rst,
    input rx_in,
    output reg rx_out,
    output reg bit_err, bit_valid
    );
    
    reg [1:0] state,n_state;
    reg [4:0] tick_counter = 5'b0;
    reg [3:0] bit_counter = 4'b0;
    
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter DATA = 2'b10;
    parameter STOP = 2'b11;
    
    // WRONG APPROACH!!
    
//    always @ (posedge baud_tickx16)
//    begin
//        if(tick_counter == 16)
//            tick_counter <= 0;
//        else
//            tick_counter <= tick_counter + 1'b1;
//    end
    
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            rx_out <= 1;
            state <= IDLE;
            bit_err = 1'b0;
            bit_valid = 1'b0;
            bit_counter <= 4'b0;
        end
        
        else
        begin
            state <= n_state;
            case(state)
                START:  begin
//                            if(rx_in == 0)
//                                bit_err <= 0;
//                            else
//                                bit_err <= 1;
                        end
                        
                DATA:   begin
//                            bit_valid <= 1'b0;
//                            if(tick_counter == 7 && bit_err == 0)
//                                if(bit_counter <= 7)
//                                begin
//                                    rx_out <= rx_in;
//                                    bit_valid <= 1'b1;
//                                    bit_counter <= bit_counter + 1'b1;
//                                end
//                                else
//                                begin
//                                    bit_counter <= 4'b0;
//                                end
//                            else
//                                bit_valid <= 1'b0;
                        end
                        
                STOP:   begin
//                            if(tick_counter == 7)
//                                if(rx_in == 1)
                        end
            endcase
        end       
    end
    
    always @ (*)
    begin
         n_state = state;
         case(state)
                IDLE:   begin
                            if(rx_in == 0)
                            begin
                                n_state = START;
                            end
                        end
                        
                START:  begin
                            if(tick_counter == 7)
                            begin
                                if(rx_in == 0)
                                    bit_err = 0;
                                else
                                    bit_err = 1;
                                    
                                n_state = DATA;
                            end
                        end
                        
                DATA:   begin
                            bit_valid <= 1'b0;
                            if(tick_counter == 7 && bit_err == 0)
                                if(bit_counter <= 7)
                                begin
                                    rx_out <= rx_in;
                                    bit_valid <= 1'b1;
                                    bit_counter <= bit_counter + 1'b1;
                                    n_state = DATA;
                                end
                                else
                                begin
                                    bit_counter <= 4'b0;
                                    n_state = STOP;
                                end
                            else
                                bit_valid <= 1'b0;    
                        end
                        
                STOP:   begin
                            if(tick_counter == 7)
                                n_state = IDLE;
                        end
            endcase   
    end
endmodule
