`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IISc
// Engineer: Malla Kamal Sai
// 
// Create Date: 02/03/2026 01:36:40 AM
// Design Name: 
// Module Name: FIFO
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


module FIFO #(  parameter FIFO_WIDTH = 8,
                parameter FIFO_DEPTH = 16,
                parameter FIFO_addr = 5)
    (
    input wr_clk,rd_clk,
    input wr_reset,rd_reset,
    input wr_en,rd_en,
    input [FIFO_WIDTH-1 : 0] data_in,
    output wire full,empty,
    output wire [FIFO_WIDTH-1:0] data_out
    );
    wire [FIFO_addr-1:0] wr_ptr_gr,wr_ptr,rd_ptr_gr,rd_ptr,wr_ptr_gr_syn,rd_ptr_gr_syn;
    
    FIFO_wptr F0 (  .rd_ptr_gr_syn(rd_ptr_gr_syn), .wr_clk(wr_clk),
                    .wr_en(wr_en), .wr_reset(wr_reset), 
                    .wr_ptr_gr(wr_ptr_gr), .wr_ptr(wr_ptr), 
                    .wr_full(full));
    synchronizer F1 (.data_in(wr_ptr_gr), .clk(rd_clk), .reset(rd_reset),
                        .data_out(wr_ptr_gr_syn));
    FIFO_rptr F2 (  .wr_ptr_gr_syn(wr_ptr_gr_syn), .rd_clk(rd_clk),
                    .rd_en(rd_en), .rd_reset(rd_reset),
                    .rd_ptr_gr(rd_ptr_gr), .rd_ptr(rd_ptr),
                    .rd_empty(empty));
    synchronizer F3 (.data_in(rd_ptr_gr), .clk(wr_clk), .reset(wr_reset),
                        .data_out(rd_ptr_gr_syn));
    FIFO_mem F4 (   .wr_clk(wr_clk), .rd_clk(rd_clk), 
                    .wr_reset(wr_reset), .rd_reset(rd_reset),
                    .wr_en(wr_en), .rd_en(rd_en), .wr_full(full), 
                    .wr_ptr(wr_ptr), .rd_ptr(rd_ptr),
                    .wr_data(data_in), .rd_data(data_out));                                                                                 
endmodule
