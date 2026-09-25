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

module tx_uart(
    input baud_tickx16,
    input uart_clk, rst,
    input shift_full,
    input tx_bit,
    output reg tx_out, tx_receive
    );
    
    reg [2:0] state,n_state;
    reg [3:0] tick_counter;
    reg [2:0] bit_counter;
    
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;
     
    always @ (posedge uart_clk)
    begin
        if(!rst)
        begin
            tx_out <= 1'b1;
            tx_receive <= 1'b0;
            state <= IDLE;
            n_state <= IDLE;
            bit_counter <= 3'b0;
            tick_counter <= 4'b0;
        end
        
        else
        begin
            
            state <= n_state;
            tx_receive <= 1'b0;
            
            if(baud_tickx16)
                tick_counter <= tick_counter + 1'b1;
                
            case(state)
                IDLE:   begin
                            if(tick_counter == 4'd7 && baud_tickx16)
                                if(shift_full)
                                begin
                                    tick_counter <= 4'b0;
                                end
                        end            
            
                START:  begin
                        if(tick_counter == 4'd7 && baud_tickx16)
                            begin
                                tx_out <= 1'b0;
                                tick_counter <= 4'b0;
                                bit_counter <= 3'b0;
                                tx_receive <= 1'b1;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 4'd15 && baud_tickx16)
                            begin
                                if(bit_counter < 3'd7)
                                begin
                                    tx_receive <= 1'b1;
                                    tx_out <= tx_bit;
                                    bit_counter <= bit_counter + 1'b1;
                                end
                                
                                else if(bit_counter == 3'd7)
                                begin
                                    tx_out <= tx_bit;
                                    bit_counter <= bit_counter + 1'b1;
                                end                                    
                            end                                
                        end
                        
                STOP:   begin
                            if(tick_counter == 4'd15 && baud_tickx16)
                                begin
                                    tx_out <= 1'b1;
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
                            if(tick_counter == 4'd7 && baud_tickx16)
                                if(shift_full)
                                begin
                                    n_state = START;
                                end
                                else
                                begin
                                    n_state = IDLE;
                                end
                        end
                        
                START:  begin
                            if(tick_counter == 4'd7 && baud_tickx16)
                            begin
                                n_state = DATA;
                            end
                        end
                        
                DATA:   begin
                            if(tick_counter == 4'd15 && baud_tickx16)
                                if(bit_counter == 3'd7)
                                    begin                                  
                                        n_state = STOP;
                                    end                                
                        end
                        
                STOP:   begin
                            if(tick_counter == 4'd15 && baud_tickx16)
                                    n_state = IDLE;
                        end
            endcase   
    end
endmodule
