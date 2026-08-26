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


module fsm(
input clk,rst,
input [7:0]fifo_data,
input fifo_empty,rd_en,
output reg pkt_valid,
output reg [7:0]chk_sum=0,
output reg [7:0]pkt_len,
output reg pkt_data_full=0,
output reg [7:0]byte_out=0
);  

integer i=0,j,k,z=0;
reg [2:0]state,n_state;
reg [7:0]pkt_data[0:15];
reg [7:0]pkt_out[0:15];
reg [7:0]calc_chk_sum=0,end_byte=0;

parameter idle=3'b000;
parameter read_len=3'b001;
parameter read_data=3'b010;
parameter checksum_calc=3'b011;
parameter read_end=3'b100;

always @(posedge clk)
begin
    if(!rst)
    begin
        pkt_valid<=0;
        pkt_len<=0;
        byte_out<=8'h00;
        calc_chk_sum<=8'h00;
        //busy<=1'b0;
        for(j=0;j<=4'hF;j=j+1'b1)
            pkt_data[j]<=0;
            pkt_out[j]<=0;
        state<=idle;
    end
    
    else
    begin
        state<=n_state;
       // pkt_valid=1'b0;
        
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
                end_byte<=fifo_data; 
            end
                    
            read_end:
            begin
                if(end_byte==8'hFF)
                begin
                    pkt_valid<=1'b1;
                    i<=1'b0;
                    for(k=0;k<pkt_len;k=k+1)
                        pkt_out[k]<=pkt_data[k];
                    calc_chk_sum<=8'h00; 
                end
                else
                begin
                    $display("Packet has no end.Invalid packet."); 
                    i<=0;
                end                                  
            end
        endcase 
        
        //if(busy)
        //begin
            if(pkt_valid==1'b1)
            begin
                byte_out<=pkt_out[z];
                z<=z+1'b1;
                if(z==pkt_len)
                begin
                    //pkt_len<=8'h00;
                    pkt_valid<=1'b0;
                    end_byte<=8'h00;
                    byte_out<=8'h00;
                    //calc_chk_sum<=8'h00;
                    z<=1'b0; 
                    for(j=0;j<=4'hF;j=j+1'b1)
                        pkt_out[j]<=8'h00;  
                   // busy=1'b0;    
                end
            end 
        //end
    end
end
always @(*)
begin
    n_state=state;
    
    case(state)
        idle: //idle state -> will check for the fifo_empty and rd_en signals. Also checks for the header byte.
        begin
            if(!fifo_empty && rd_en /*&& !busy*/)
                if(fifo_data==8'hAA) 
                    n_state=read_len;              
            else
                n_state=idle;  
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
                begin
                    if(i==(5'd16))
                        pkt_data_full=1'b1;
                    n_state=checksum_calc;    
                end
            end
            else
                n_state=idle;
        end
                  
        checksum_calc:// read_checksum state -> reads the checksum data. Checks if the calculated checksum is equal to the received checksum data.
        begin 
            if(chk_sum==calc_chk_sum)
                n_state=read_end;
            else
            begin
                $display("Data invalid.Failed in checksum.");  
                calc_chk_sum=0;
                i<=0;                            
                n_state=idle;
            end
        end 
                              
        read_end:// read_end -> reads the end of the packet.
        begin
            if(fifo_data==8'hAA)
                n_state=read_len;
            else
                n_state=idle;                    
        end             
    endcase  
end
endmodule
