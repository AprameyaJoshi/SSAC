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
    output reg shift_en, byte_valid, framing_err
    );
    
    reg [2 :0] state,n_state;
    reg [3:0] tick_counter;
    reg [2:0] bit_counter;
    
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;
    parameter ERR = 3'b100;
    
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
            rx_out <= 0;
            state <= IDLE;
            shift_en <= 1'b0;
            byte_valid <= 1'b0;
            framing_err <= 1'b0;
            bit_counter <= 3'b0;
            tick_counter <= 4'b0;
        end
        
        else
        begin
            state <= n_state;
            shift_en <= 1'b0;
            byte_valid <= 1'b0;
            framing_err <= 1'b0;
            
            if(baud_tickx16)
                tick_counter <= tick_counter + 1'b1; 
                
            case(state)
                IDLE:   begin
                            if(rx_in == 0)
                                tick_counter <= 4'b0;
                        end            
            
                START:  begin
                        if(tick_counter == 7 && baud_tickx16)
                            if(rx_in == 0)
                            begin
                                tick_counter <= 4'b0;
                                bit_counter <= 3'b0;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 15 && baud_tickx16)
                            begin
                                if(bit_counter <= 7)
                                begin
                                    rx_out <= rx_in;                                    
                                    shift_en <= 1'b1;
                                    bit_counter <= bit_counter + 1'b1;
                                end
                            end
                                
                        end
                        
                STOP:   begin
                            if(tick_counter == 15 && baud_tickx16)
                                if(rx_in == 1)
                                begin
                                    byte_valid <= 1'b1;
                                end
                                else
                                begin
                                    framing_err <= 1'b1;
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
                            if(tick_counter == 7 && baud_tickx16)
                            begin
                                if(rx_in == 0)
                                    n_state = DATA;
                                else
                                    n_state = IDLE;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 15 && baud_tickx16)
                                if(bit_counter == 7)
                                    begin                                  
                                        n_state = STOP;
                                    end                                
                        end
                        
                STOP:   begin
                            if(tick_counter == 15 && baud_tickx16)
                                if(rx_in == 1)
                                    n_state = IDLE;
                                else
                                    n_state = ERR;
                        end
                
                ERR:begin
                            if(rx_in == 1)
                                n_state = IDLE;
                        end
            endcase   
    end
endmodule
