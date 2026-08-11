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

output reg pkt_valid,pkt_err,
output reg [7:0]chk_sum,
output reg [7:0]pkt_len,
output reg pkt_data_full
);
reg [3:0]i,j,inv=0;
reg [2:0]state;
reg [7:0]pkt_data[0:15];
reg [7:0]inv_pkt_data[0:15];
reg [7:0]calc_chk_sum;
parameter idle=3'b000;
parameter read_header=3'b001;
parameter read_len=3'b010;
parameter read_data=3'b011;
parameter checksum_calc=3'b100;
parameter read_end=3'b11;

always @(posedge clk)
begin
    if(!rst)
    begin
        pkt_valid<=0;
        pkt_err<=0;
        pkt_len<=0;
        for(i=0;i<=4'hF;i=i+1'b1)
            pkt_data[i]<=0;
    end
    else
    begin
        state<=idle;
        case(state)
        idle:begin
                //idle state -> will check for the fifo_empty and rd_en signals.
                if(!fifo_empty && rd_en)
                    state<=read_header; 
                else
                    state<=idle;  
             end
             
        read_header:begin
                    //read_header state -> jumps to next state iff fifo data is AAh.
                        if(fifo_data==8'hAA) 
                            state<=read_len;
                        else
                        begin
                            inv_pkt_data[inv]<=fifo_data;
                            inv<=inv+1'b1;
                            state<=idle;
                            pkt_err=1'b1;
                        end
                    pkt_err=1'b0;                           
                    end
        
        read_len:begin
                 //read_len state -> reads the number of data present in a particular packet.
                    if(fifo_data>4'hF)
                    begin
                        $display("Number of data incoming is greater than the storage space available.");
                        inv_pkt_data[inv]<=fifo_data;
                        inv<=inv+1'b1;
                    end
                    else
                    begin
                        pkt_len<=fifo_data; 
                        state<=read_data; 
                    end 
                 end
        
        read_data:begin
                  //read_data state -> stores the data in an array with depth 16.
                    i=0;
                    while((i<pkt_len)&&(!fifo_empty))
                    begin
                        if(fifo_empty)
                        begin
                            $display("FIFO empty.");
                            for(j=0;j<=4'hF;j=j+1)
                                pkt_data[j]<=0;                               
                            state<=idle;                            
                        end
                        pkt_data[i]<=fifo_data; 
                        i<=i+1'b1;     
                    end
                    if(!fifo_empty)
                    begin
                        if(i==4'hF)
                            pkt_data_full=1'b1;
                        state<=checksum_calc;
                    end
                  end
                  
        checksum_calc:begin 
                      // read_checksum state -> reads the checksum data. Checks if the calculated checksum is equal to the received checksum data.
                        chk_sum<=fifo_data;
                        for(i=0;i<pkt_len;i=i+1'b1) 
                            calc_chk_sum<=calc_chk_sum+pkt_data[i];
                        if(chk_sum==calc_chk_sum)
                            state<=read_end;
                        else
                        begin
                            $display("Data invalid.Failed in checksum.");
                            for(j=0;j<=4'hF;j=j+1)
                                pkt_data[j]<=0;                               
                            state<=idle;
                        end
                      end 
                              
        read_end:begin
                 // read_end -> reads the end of the packet. 
                    if(fifo_data==8'hFF)
                    begin
                        pkt_valid=1'b1;
                        state<= idle;
                    end
                    else
                    begin
                        $display("Packet has no end.Invalid packet.");
                        for(j=0;j<=4'hF;j=j+1)
                            pkt_data[j]<=0;                               
                        state<=idle;
                    end  
                 end 
        endcase
    end
end
endmodule
