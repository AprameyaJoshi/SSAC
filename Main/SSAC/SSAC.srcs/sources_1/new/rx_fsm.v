`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2026 21:53:06
// Design Name:  
// Module Name: fsm
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


module rx_fsm(
input clk,rst,
input [7:0]fifo_data,
input fifo_empty,
output reg pkt_valid,rd_en,
output reg [7:0]chk_sum,
output reg [7:0]pkt_len,
output reg [7:0]byte_out,
output reg end_signal
);  

reg [4:0] i,j,k,z;
reg [2:0]state,n_state;
reg [7:0]pkt_data[0:15];
reg busyA,busyB;
reg active_buf;
reg draining; 
reg [7:0]lenA,lenB; 
reg [7:0]buffA[0:15];
reg [7:0]buffB[0:15];
reg [7:0]calc_chk_sum,end_byte;

parameter idle=3'b000;
parameter read_len=3'b001;
parameter read_data=3'b010;
parameter checksum_calc=3'b011;
parameter read_end=3'b100;

always @(posedge clk)
begin
    if(!rst)
    begin
        i<=0;
        j<=0;
        k<=0;
        z<=0;
        pkt_valid<=0;
        pkt_len<=0;
        byte_out<=8'h00;
        rd_en<=0;
        calc_chk_sum<=8'h00;
        busyA<=0;
        busyB<=0;
        active_buf<=0;
        draining<=0;
        lenA<=0;
        lenB<=0;
        end_byte<=0;
        chk_sum<=0;
        byte_out<=0;
        end_signal<=0;
        for(j=0;j<=4'hF;j=j+1'b1)
        begin
            pkt_data[j]<=0;
            buffA[j]<=0;
            buffB[j]<=0;
        end
        state<=idle;
    end
    
    else
    begin
        rd_en<=1;
        state<=n_state;
        
        case(state)   
            read_len: 
            begin
                if(!fifo_empty)
                begin
                    if(fifo_data>5'd15)
                    begin
                        $display("Number of data incoming is greater than the storage space available.");
                        i<=0;
                    end
                    else
                        pkt_len<=fifo_data;
                end 
            end
                   
            read_data:
            begin
                if(!fifo_empty)
                begin
                    if(i<pkt_len)
                    begin
                        pkt_data[i]<=fifo_data; 
                        calc_chk_sum<=calc_chk_sum+fifo_data;
                        i<=i+1'b1;                                            
                    end
                    if(i==pkt_len)
                        chk_sum<=fifo_data;   
                end    
            end
                    
            checksum_calc:
            begin
                if(!fifo_empty)
                begin
                    if(chk_sum==calc_chk_sum)
                        end_byte<=fifo_data;
                    else
                    begin
                        $display("Data invalid.Failed in checksum.");
                        calc_chk_sum<=0;
                        i<=0;
                    end
                end
            end
                    
            read_end:
            begin
                //if(!fifo_empty)
                begin
                    if(end_byte==8'hFF)
                    begin
                        k<=1'b0;
                        i<=1'b0;
                        calc_chk_sum<=8'h00;
                        if(!busyA)
                        begin
                            busyA<=1'b1;
                            lenA<=pkt_len;
                            buffA[0]<=pkt_len;
                            for(k=1'b1;k<=pkt_len;k=k+1)
                            begin
                                buffA[k]<=pkt_data[k-1'b1];
                            end  
                        end    
                        else if(!busyB)
                        begin
                            busyB<=1'b1;
                            lenB<=pkt_len;
                            buffB[0]<=pkt_len;
                            for(k=1'b1;k<=pkt_len;k=k+1)
                            begin
                                buffB[k]<=pkt_data[k-1'b1];
                            end  
                        end
                        end_byte<=0;
                    end
                    else
                    begin
                        $display("Packet has no end.Invalid packet."); 
                        calc_chk_sum<=0;
                        i<=0;
                    end
                end                                  
            end
        endcase 
        
    if(!draining) //this is phase 1 - to check the free buffer
    begin
        if(busyA)
        begin
            draining<=1;
            active_buf<=0;
            z<=0;
        end
        else if(busyB)
        begin
            draining<=1;
            active_buf<=1;
            z<=0;
        end
    end
    
    else //this is phase 2 - drain out the active buffer
    begin
        case(active_buf)
        0:  begin
                pkt_valid<=1'b1;
                byte_out<=buffA[z];
                z<=z+1'b1;
                if(z==lenA)
                    end_signal=1'b1;
                if(z==lenA+1'b1)
                begin
                    draining<=0;
                    busyA<=0;
                    pkt_valid<=1'b0;
                    end_signal<=0;
                    for(j=0;j<=4'd15;j=j+1)
                        buffA[j]=0;
                end
            end
            
        1:  begin
                pkt_valid<=1'b1;
                byte_out<=buffB[z];
                z<=z+1'b1;
                if(z==lenB)
                    end_signal=1'b1;
                if(z==lenB+1'b1)
                begin
                    draining<=0;
                    busyB<=0;
                    pkt_valid<=1'b0;
                    end_signal<=0;
                    for(j=0;j<=4'd15;j=j+1)
                        buffB[j]=0;
                end
            end  
        endcase
    end
    end   
end


always @(*)
begin
    n_state=state;
    
    case(state)
        idle: //idle state -> will check for the fifo_empty and rd_en signals. Also checks for the header byte.
        begin
            if(!fifo_empty)
            begin
                if(fifo_data==8'hAA) 
                    n_state=read_len;
                else
                    n_state=idle;  
            end
        end
             
        read_len://read_len state -> reads the number of data present in a particular packet.
        begin
            if(!fifo_empty)
            begin
                if(fifo_data>5'd15)
                    n_state=idle;
                else
                    n_state=read_data; 
                        
            end
        end
        
        read_data://read_data state -> stores the data in an array with depth 16.
        begin
            if(!fifo_empty)
            begin
                if(i<pkt_len)
                    n_state=read_data;
                if(i==pkt_len)
                    n_state=checksum_calc;    
//                else
//                    n_state=idle;
            end
        end
                  
        checksum_calc:// read_checksum state -> reads the checksum data. Checks if the calculated checksum is equal to the received checksum data.
        begin 
            if(!fifo_empty)
            begin
                if(chk_sum==calc_chk_sum)
                    n_state=read_end;
                else
                begin                              
                    n_state=idle;
                end
            end
        end 
                              
        read_end:// read_end -> reads the end of the packet.
        begin
            //if(!fifo_empty)
            begin
                if(fifo_data==8'hAA)
                    n_state=read_len;
                else
                    n_state=idle; 
            end                   
        end             
    endcase 
     
end
endmodule