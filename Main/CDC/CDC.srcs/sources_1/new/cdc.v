`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2026 13:20:03
// Design Name: 
// Module Name: cdc
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


module cdc (
   
    input wire wr_clk, // 50 MHz
    input wire rst_n,
    input wire [7:0] data_in,        
    input wire data_valid,     
    output wire full,
    input wire rd_clk, // 100 MHz
    output reg [7:0] data_out,
    output reg data_out_valid,
    output wire empty
);
    reg [7:0] mem [0:15];
    reg [4:0] wr_ptr_bin;
    reg [4:0] rd_ptr_bin;
    reg [4:0] wr_ptr_gray;
    reg [4:0] rd_ptr_gray;
    
    // SYNCHRONIZED POINTERS
    (* ASYNC_REG = "TRUE" *) reg [4:0] rd_gray_sync1;
    (* ASYNC_REG = "TRUE" *) reg [4:0] rd_gray_sync2;
    (* ASYNC_REG = "TRUE" *) reg [4:0] wr_gray_sync1;
    (* ASYNC_REG = "TRUE" *) reg [4:0] wr_gray_sync2;
    
    wire [4:0] wr_ptr_bin_next;
    wire [4:0] wr_ptr_gray_next;
    wire [4:0] rd_ptr_bin_next;
    wire [4:0] rd_ptr_gray_next;
    
    reg full_reg;
    reg empty_reg;
    wire full_next;
    wire empty_next;

    assign full  = full_reg;
    assign empty = empty_reg;

    assign wr_ptr_bin_next = wr_ptr_bin + ((data_valid && !full_reg) ? 5'd1 : 5'd0);

    assign wr_ptr_gray_next = (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;

    assign rd_ptr_bin_next = rd_ptr_bin + ((!empty_reg) ? 5'd1 : 5'd0);

    assign rd_ptr_gray_next = (rd_ptr_bin_next >> 1) ^ rd_ptr_bin_next;
    

    always @(posedge wr_clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            wr_ptr_bin  <= 5'd0;
            wr_ptr_gray <= 5'd0;
            full_reg    <= 1'b0;
        end
        else
        begin
            if (data_valid && !full_reg)
            begin
                mem[wr_ptr_bin[3:0]] <= data_in;
            end
            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;
            full_reg <= full_next;
        end
    end


    always @(posedge rd_clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            rd_ptr_bin <= 5'd0;
            rd_ptr_gray <= 5'd0;
            data_out <= 8'd0;
            data_out_valid <= 1'b0;
            empty_reg <= 1'b1;
        end
        else
        begin
            data_out_valid <= 1'b0;
            if (!empty_reg)
            begin
                data_out <= mem[rd_ptr_bin[3:0]];
                data_out_valid <= 1'b1;
            end
            rd_ptr_bin <= rd_ptr_bin_next;
            rd_ptr_gray <= rd_ptr_gray_next;
            empty_reg <= empty_next;
        end
    end

    always @(posedge wr_clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            rd_gray_sync1 <= 5'd0;
            rd_gray_sync2 <= 5'd0;
        end
        else
        begin
            rd_gray_sync1 <= rd_ptr_gray;
            rd_gray_sync2 <= rd_gray_sync1;
        end
    end

    always @(posedge rd_clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            wr_gray_sync1 <= 5'd0;
            wr_gray_sync2 <= 5'd0;
        end
        else
        begin
            wr_gray_sync1 <= wr_ptr_gray;
            wr_gray_sync2 <= wr_gray_sync1;
        end
    end

    assign empty_next =(rd_ptr_gray_next == wr_gray_sync2);
    assign full_next =(wr_ptr_gray_next =={~rd_gray_sync2[4:3],rd_gray_sync2[2:0]});

endmodule