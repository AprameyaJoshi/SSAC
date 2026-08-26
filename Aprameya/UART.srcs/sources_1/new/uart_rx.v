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

module uart_rx(
    input baud_tickx16,
    input uart_clk, rst,
    input rx_in,
    output reg rx_out,
    output reg shift_en, byte_valid
    );
    
    reg [1 :0] state,n_state;
    reg [3:0] tick_counter = 4'b0;
    reg [2:0] bit_counter = 3'b0;
    
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
            shift_en <= 1'b0;
            byte_valid <= 1'b0;
            bit_counter <= 3'b0;
        end
        
        else
        begin
            state <= n_state;
            shift_en <= 1'b0;
            byte_valid <= 1'b0;
            if(baud_tickx16)
                tick_counter <= tick_counter + 1'b1;
            case(state)
                START:  begin
                        if(tick_counter == 8)
                            if(rx_in == 0)
                            begin
                                tick_counter <= 4'b0;
                                bit_counter <= 3'b0;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 15)
                                if(bit_counter <= 7)
                                begin
                                    rx_out <= rx_in;                                    
                                    shift_en <= 1'b1;
                                    tick_counter <= 1'b0;
                                    bit_counter <= bit_counter + 1'b1;
                                end
                        end
                        
                STOP:   begin
                            if(tick_counter == 15)
                                if(rx_in == 1)
                                begin
                                    byte_valid <= 1'b1;
                                end
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
                            else
                            begin
                                n_state = IDLE;
                            end
                        end
                        
                START:  begin
                            if(tick_counter == 8)
                            begin
                                if(rx_in == 0)
                                    n_state = DATA;
                                else
                                    n_state = IDLE;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 15)
                                if(bit_counter == 7)
                                    begin                                  
                                        n_state = STOP;
                                    end                                
                        end
                        
                STOP:   begin
                            if(tick_counter == 15)
                                n_state = IDLE;
                        end
            endcase   
    end
endmodule
