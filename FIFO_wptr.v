`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 02:12:10 AM
// Design Name: 
// Module Name: FIFO_wptr
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


module FIFO_wptr #(parameter FIFO_addr = 5)(
    input [FIFO_addr-1:0] rd_ptr_gr_syn,
    input wr_clk,
    input wr_en,
    input wr_reset,
    output wire [FIFO_addr-1:0] wr_ptr_gr,
    output reg [FIFO_addr-1:0] wr_ptr,
    output reg wr_full
    );
    wire full;
    wire [FIFO_addr-1:0] rd_ptr;
    always@(posedge wr_clk or posedge wr_reset)
    begin
        if(wr_reset)
        begin
            wr_ptr <= 0;
        end
        else
        begin
            if(wr_en && !full)
            begin
                wr_ptr <= wr_ptr + 1;                
            end
        end
    end
    always@(posedge wr_clk or posedge wr_reset)
    begin
        if(wr_reset)
        begin
            wr_full <= 0;
        end
        else
        begin
            wr_full <= full;//synchronous output
        end
    end
    assign wr_ptr_gr = wr_ptr ^ (wr_ptr >> 1);//binary to grey
    //grey to binary
    assign rd_ptr[FIFO_addr-1] = rd_ptr_gr_syn[FIFO_addr-1];
    genvar i;
    generate 
        for(i=0;i<FIFO_addr-1;i=i+1)
        begin
            assign rd_ptr[i] = rd_ptr[i+1] ^ rd_ptr_gr_syn[i];
        end
    endgenerate
    //full condition
    assign full =   (wr_ptr[FIFO_addr-2:0] == rd_ptr[FIFO_addr-2:0]) && 
                    (wr_ptr[FIFO_addr-1]!=rd_ptr[FIFO_addr-1]);    
endmodule
