`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IISc
// Engineer: Malla Kamal Sai
// 
// Create Date: 02/03/2026 03:53:17 AM
// Design Name: 
// Module Name: tb_FIFO
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


`timescale 1ns/1ps

module tb_FIFO;

    localparam FIFO_WIDTH = 8;
    localparam FIFO_DEPTH = 16;
    localparam FIFO_addr  = 5;   // 4 addr bits + 1 wrap bit

    reg  wr_clk, rd_clk;
    reg  wr_reset, rd_reset;
    reg  wr_en, rd_en;
    reg  [FIFO_WIDTH-1:0] data_in;
    wire full, empty;
    wire [FIFO_WIDTH-1:0] data_out;

    integer write_count;
    integer read_count;
    integer errors = 0;

    // -------- Clocks --------
    always #12.5 wr_clk = ~wr_clk;   // 40 MHz
    always #10   rd_clk = ~rd_clk;   // 50 MHz

    // -------- DUT --------
    FIFO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .FIFO_addr(FIFO_addr)
    ) DUT (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .wr_reset(wr_reset),
        .rd_reset(rd_reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

    initial begin
        // Init
        wr_clk   = 0;
        rd_clk   = 0;
        wr_reset = 1;
        rd_reset = 1;
        wr_en    = 0;
        rd_en    = 0;
        data_in  = 0;
        write_count = 0;
        read_count  = 0;

        #100;
        wr_reset = 0;
        rd_reset = 0;

        $display("\n==== TEST 1: FILL FIFO ====");

        // ---------------- WRITE PHASE ----------------
        repeat (FIFO_DEPTH) begin
            @(posedge wr_clk);

            if (full) begin
                $error("ERROR: FIFO became full too early at write %0d",
                        write_count);
                errors = errors + 1;
            end

            wr_en   <= 1;
            data_in <= write_count[7:0];

            $display("WRITE %0d at time %0t",
                      write_count, $time);

            write_count = write_count + 1;
        end

        @(posedge wr_clk);
        wr_en <= 0;

        #26;

        if (!full) begin
            $error("ERROR: FIFO should be FULL after %0d writes",
                    FIFO_DEPTH);
            errors = errors + 1;
        end else begin
            $display("FIFO correctly reports FULL");
        end

        #200;

        $display("\n==== TEST 2: DRAIN FIFO (1-cycle latency) ====");

        // ---------------- READ PHASE ----------------
        @(posedge rd_clk);
        rd_en <= 1;
        @(posedge rd_clk);
        repeat (FIFO_DEPTH) begin

            // request read
            //@(posedge rd_clk);

            if (empty) begin
                $error("ERROR: FIFO became EMPTY too early at read %0d",
                        read_count);
                errors = errors + 1;
            end

            rd_en <= 1;

            // wait ONE FULL rd_clk for data
            @(posedge rd_clk);

            if (data_out !== read_count[7:0]) begin
                $error("ERROR: Mismatch! Expected %0d, got %0d at time %0t",
                        read_count, data_out, $time);
                errors = errors + 1;
            end else begin
                $display("READ %0d (OK) at time %0t",
                          data_out, $time);
            end

            read_count = read_count + 1;
        end

        @(posedge rd_clk);
        rd_en <= 0;

        #1;
        if (!empty) begin
            $error("ERROR: FIFO should be EMPTY after draining");
            errors = errors + 1;
        end else begin
            $display("FIFO correctly reports EMPTY");
        end

        //#50;
        if (errors == 0)
            $display("\nTEST PASSED: No errors detected.");
        else
            $display("\nTEST FAILED: %0d errors detected.", errors);

        $finish;
    end

endmodule




