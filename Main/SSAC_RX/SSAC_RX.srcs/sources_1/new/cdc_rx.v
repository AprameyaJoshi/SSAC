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


module cdc_rx (
    // =========================================================
    // ASA SIDE - 50 MHz WRITE CLOCK DOMAIN
    // =========================================================
    input  wire       wr_clk,          // 50 MHz
    input  wire       rst_n,

    input  wire [7:0] data_in,         // ASA byte_out
    input  wire       data_valid,      // ASA byte_valid
    output wire       full,

    // =========================================================
    // APJ SIDE - 100 MHz READ CLOCK DOMAIN
    // =========================================================
    input  wire       rd_clk,          // 100 MHz

    output reg  [7:0] data_out,
    output reg        data_out_valid,
    output wire       empty
);

    // =========================================================
    // FIFO MEMORY
    // 16 locations, each location stores 8 bits
    // =========================================================

    reg [7:0] mem [0:15];


    // =========================================================
    // POINTERS
    //
    // 16 locations need 4 address bits.
    // We use 5-bit pointers because the extra bit is needed
    // to distinguish FIFO FULL from FIFO EMPTY.
    // =========================================================

    reg [4:0] wr_ptr_bin;
    reg [4:0] rd_ptr_bin;

    reg [4:0] wr_ptr_gray;
    reg [4:0] rd_ptr_gray;


    // =========================================================
    // SYNCHRONIZED POINTERS
    //
    // Read pointer must cross into write clock domain.
    // Write pointer must cross into read clock domain.
    // =========================================================

    (* ASYNC_REG = "TRUE" *) reg [4:0] rd_gray_sync1;
    (* ASYNC_REG = "TRUE" *) reg [4:0] rd_gray_sync2;

    (* ASYNC_REG = "TRUE" *) reg [4:0] wr_gray_sync1;
    (* ASYNC_REG = "TRUE" *) reg [4:0] wr_gray_sync2;


    // =========================================================
    // NEXT POINTER VALUES
    // =========================================================

    wire [4:0] wr_ptr_bin_next;
    wire [4:0] wr_ptr_gray_next;

    wire [4:0] rd_ptr_bin_next;
    wire [4:0] rd_ptr_gray_next;


    // =========================================================
    // FULL / EMPTY REGISTERS
    // =========================================================

    reg full_reg;
    reg empty_reg;

    wire full_next;
    wire empty_next;


    assign full  = full_reg;
    assign empty = empty_reg;


    // =========================================================
    // WRITE POINTER NEXT VALUE
    //
    // Increase pointer only when:
    //
    // data_valid = 1
    // AND
    // FIFO is not full
    // =========================================================

    assign wr_ptr_bin_next =
        wr_ptr_bin +
        ((data_valid && !full_reg) ? 5'd1 : 5'd0);


    // =========================================================
    // BINARY -> GRAY CONVERSION
    //
    // Gray = Binary XOR (Binary >> 1)
    // =========================================================

    assign wr_ptr_gray_next =
        (wr_ptr_bin_next >> 1) ^ wr_ptr_bin_next;


    // =========================================================
    // READ POINTER
    //
    // Our design automatically reads whenever FIFO is not empty.
    // =========================================================

    assign rd_ptr_bin_next =
        rd_ptr_bin +
        ((!empty_reg) ? 5'd1 : 5'd0);


    assign rd_ptr_gray_next =
        (rd_ptr_bin_next >> 1) ^ rd_ptr_bin_next;


    // =========================================================
    // WRITE SIDE
    // Runs only using ASA's 50 MHz clock
    // =========================================================

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

            // Write only if ASA says data is valid
            // and FIFO has free space.

            if (data_valid && !full_reg)
            begin
                mem[wr_ptr_bin[3:0]] <= data_in;
            end

            wr_ptr_bin  <= wr_ptr_bin_next;
            wr_ptr_gray <= wr_ptr_gray_next;

            full_reg <= full_next;

        end

    end


    // =========================================================
    // READ SIDE
    // Runs using APJ's 100 MHz clock
    // =========================================================

    always @(posedge rd_clk or negedge rst_n)
    begin

        if (!rst_n)
        begin

            rd_ptr_bin      <= 5'd0;
            rd_ptr_gray     <= 5'd0;

            data_out        <= 8'd0;
            data_out_valid  <= 1'b0;

            empty_reg       <= 1'b1;

        end

        else
        begin

            // Default:
            // no output byte on this clock cycle

            data_out_valid <= 1'b0;


            // If FIFO contains something,
            // read one byte.

            if (!empty_reg)
            begin

                data_out <= mem[rd_ptr_bin[3:0]];

                data_out_valid <= 1'b1;

            end


            rd_ptr_bin  <= rd_ptr_bin_next;
            rd_ptr_gray <= rd_ptr_gray_next;

            empty_reg <= empty_next;

        end

    end


    // =========================================================
    // CDC:
    // READ POINTER -> WRITE CLOCK DOMAIN
    //
    // Two flip-flop synchronizer
    // =========================================================

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


    // =========================================================
    // CDC:
    // WRITE POINTER -> READ CLOCK DOMAIN
    //
    // Two flip-flop synchronizer
    // =========================================================

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


    // =========================================================
    // EMPTY DETECTION
    //
    // FIFO is empty when the NEXT read pointer
    // reaches the synchronized write pointer.
    // =========================================================

    assign empty_next =
        (rd_ptr_gray_next == wr_gray_sync2);


    // =========================================================
    // FULL DETECTION
    //
    // For a Gray-code asynchronous FIFO,
    // full occurs when write pointer catches the read pointer
    // after wrapping around the FIFO.
    //
    // The upper two Gray bits are inverted.
    // =========================================================

    assign full_next =
        (wr_ptr_gray_next ==
        {~rd_gray_sync2[4:3],
          rd_gray_sync2[2:0]});


endmodule