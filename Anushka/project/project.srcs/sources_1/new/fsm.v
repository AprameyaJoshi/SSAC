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
input [7:0]chk_ans,
output reg [7:0]pkt_len,
output reg pkt_data_full,
output reg [7:0]pkt_data[0:15],
output reg [7:0]inv_pkt_data[0:15]
);
reg [3:0]i=0,j=0,inv=0;
reg [2:0]state;
parameter idle=3'b000;
parameter read_header=3'b001;
parameter read_len=3'b010;
parameter read_data=3'b011;
parameter read_checksum=3'b100;
parameter read_end=3'b101;

//idle,header,length,data,checksum,end
//checksum state only to read checksum value. Validation is done in another verilog program.
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
                    if(fifo_data>4'hE)
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
                    while((i<pkt_len)&&(!fifo_empty))
                    begin
                       pkt_data[i]<=fifo_data; 
                       i<=i+1'b1;
                    end
                    if(i==4'hF)
                        pkt_data_full=1'b1;
                    state<=read_checksum;
                  end
                  
        read_checksum:begin 
                      // read_checksum state -> reads the checksum data. Checks if the calculated checksum is equal to the received checksum data.
                        chk_sum<=fifo_data;
                        if(chk_sum==chk_ans)
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
                    if(fifo_data==8'hFF)
                    begin
                        pkt_valid=1'b1;
                        state<= idle;
                    end
                    else
                        state<=read_data; //??   
                 end 
        endcase
    end
end
endmodule
