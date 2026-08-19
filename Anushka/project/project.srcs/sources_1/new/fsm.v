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
output reg [7:0]chk_sum=0,
output reg [7:0]pkt_len,
output reg pkt_data_full=0,
output reg [7:0]byte_out=0
);
integer i=0,j,k,z=0;
reg [2:0]state,n_state;
reg [7:0]pkt_data[0:15];
reg [7:0]calc_chk_sum=0;

parameter idle=3'b000;
parameter read_header=3'b001;
parameter read_len=3'b010;
parameter read_data=3'b011;
parameter checksum_calc=3'b100;
parameter read_end=3'b101;

always @(posedge clk)
begin
    if(!rst)
    begin
        pkt_valid<=0;
        pkt_err<=0;
        pkt_len<=0;
        for(j=0;j<=4'hF;j=j+1'b1)
            pkt_data[j]<=0;
        state<=idle;
    end
    else
    begin
       state<=n_state;
       if(pkt_valid==1'b1)
            begin
                byte_out<=pkt_data[z];
                z<=z+1'b1;
                if(z==pkt_len)
                    begin
                        pkt_valid<=1'b0;
                        z<=0;                   
                        n_state<=idle;
                    end        
            end
    end
end
always @(*)
begin
        n_state=state;
        case(state)
        idle:begin
                //idle state -> will check for the fifo_empty and rd_en signals.
                if(!fifo_empty && rd_en)
                    n_state=read_header; 
                else
                    n_state=idle;  
             end
             
        read_header:begin
                    //read_header state -> jumps to next state iff fifo data is AAh.
                        
                        pkt_err=1'b0;  
                        if(!fifo_empty)
                        begin
                            if(fifo_data==8'hAA) 
                                n_state=read_len;
                            else
                            begin
                                n_state=idle;
                                pkt_err=1'b1;
                            end                         
                        end
                    end
        
        read_len:begin
                 //read_len state -> reads the number of data present in a particular packet.
                    if(!fifo_empty)
                    begin
                        if(fifo_data>5'd16)
                        begin
                            $display("Number of data incoming is greater than the storage space available.");
                            n_state=idle;
                        end
                        else
                        begin
                            pkt_len=fifo_data; 
                            n_state=read_data; 
                        end 
                    end
                 end
        
        read_data:begin
                  //read_data state -> stores the data in an array with depth 16.
                    if(!fifo_empty)
                    begin
                        if(i<=pkt_len)
                        begin
                            pkt_data[i]=fifo_data; 
                            i=i+1'b1;
                        end 
                        if(i>pkt_len)
                        begin
                            if(i==(5'd16))
                                pkt_data_full=1'b1;
                            n_state=checksum_calc;    
                        end
                    end
                    else
                        n_state=idle;
                  end
                  
        checksum_calc:begin 
                      // read_checksum state -> reads the checksum data. Checks if the calculated checksum is equal to the received checksum data.
                        calc_chk_sum=8'h00;
                        chk_sum=pkt_data[i-1'b1];
                        for(k=0;k<pkt_len;k=k+1'b1) 
                        begin
                            calc_chk_sum=calc_chk_sum+pkt_data[k];
                        end
                        if(chk_sum==calc_chk_sum)
                            n_state=read_end;
                        else
                        begin
                            $display("Data invalid.Failed in checksum.");                              
                            n_state=idle;
                        end
                      end 
                              
        read_end:begin
                 // read_end -> reads the end of the packet.
                    //i=0; 
                    if(fifo_data==8'hFF)
                    
                        pkt_valid=1'b1; 
//                        for(z=0;z<pkt_len;z=z+1'b1)
                    
                    else
                    begin
                        $display("Packet has no end.Invalid packet.");                               
                        n_state=idle;
                    end  
                 end 
                 
        endcase
  
end
endmodule
