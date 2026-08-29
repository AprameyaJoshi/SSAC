`timescale 1ns/1ps

module cdc_tb;

    reg wr_clk;
    reg rd_clk;
    reg rst_n;

    reg  [7:0] data_in;
    reg        data_valid;

    wire       full;
    wire [7:0] data_out;
    wire       data_out_valid;
    wire       empty;


    // =========================================================
    // DUT
    // =========================================================

    cdc dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),

        .data_in(data_in),
        .data_valid(data_valid),
        .full(full),

        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .empty(empty)
    );


    // =========================================================
    // 50 MHz WRITE CLOCK
    //
    // Period = 20 ns
    // =========================================================

    initial
    begin
        wr_clk = 0;

        forever
            #10 wr_clk = ~wr_clk;
    end


    // =========================================================
    // 100 MHz READ CLOCK
    //
    // Period = 10 ns
    // =========================================================

    initial
    begin
        rd_clk = 0;

        forever
            #5 rd_clk = ~rd_clk;
    end


    // =========================================================
    // TEST
    // =========================================================

    initial
    begin

        // Initial values
        rst_n      = 0;
        data_in    = 8'h00;
        data_valid = 0;


        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        #40;

        rst_n = 1;


        // Wait a little
        #20;


        // -----------------------------------------------------
        // SEND BYTE 1 = 31
        // -----------------------------------------------------

        @(negedge wr_clk);

        data_in    = 8'h31;
        data_valid = 1;


        @(negedge wr_clk);

        data_valid = 0;


        // -----------------------------------------------------
        // SEND BYTE 2 = 99
        // -----------------------------------------------------

        @(negedge wr_clk);

        data_in    = 8'h99;
        data_valid = 1;


        @(negedge wr_clk);

        data_valid = 0;


        // -----------------------------------------------------
        // SEND BYTE 3 = 20
        // -----------------------------------------------------

        @(negedge wr_clk);

        data_in    = 8'h20;
        data_valid = 1;


        @(negedge wr_clk);

        data_valid = 0;


        // -----------------------------------------------------
        // SEND BYTE 4 = 54
        // -----------------------------------------------------

        @(negedge wr_clk);

        data_in    = 8'h54;
        data_valid = 1;


        @(negedge wr_clk);

        data_valid = 0;


        // -----------------------------------------------------
        // Let FIFO finish transmitting
        // -----------------------------------------------------

        #300;


        $finish;

    end


    // =========================================================
    // DISPLAY RECEIVED DATA
    // =========================================================

    always @(posedge rd_clk)
    begin

        if (data_out_valid)
        begin

            $display(
                "Time = %0t ns | Received = %h",
                $time,
                data_out
            );

        end

    end


endmodule