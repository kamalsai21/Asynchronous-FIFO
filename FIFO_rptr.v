`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 02:52:07 AM
// Design Name: 
// Module Name: FIFO_rptr
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


module FIFO_rptr #(parameter FIFO_addr = 5)(
    input [FIFO_addr-1:0] wr_ptr_gr_syn,
    input rd_clk,
    input rd_en,
    input rd_reset,
    output wire [FIFO_addr-1:0] rd_ptr_gr,
    output reg [FIFO_addr-1:0] rd_ptr,
    output reg rd_empty
    );
    wire empty;
    wire [FIFO_addr-1:0] wr_ptr;
    always@(posedge rd_clk or posedge rd_reset)
    begin
        if(rd_reset)
        begin
            rd_ptr <= 0;
        end
        else
        begin
            if(rd_en && !empty)
            begin
                rd_ptr <= rd_ptr + 1;                
            end
        end
    end
    always@(posedge rd_clk or posedge rd_reset)
    begin
        if(rd_reset)
        begin
            rd_empty <= 0;
        end
        else
        begin
            rd_empty <= empty;//synchronous output
        end
    end
    assign rd_ptr_gr = rd_ptr ^ (rd_ptr >> 1);//binary to grey
    //grey to binary
    assign wr_ptr[FIFO_addr-1] = wr_ptr_gr_syn[FIFO_addr-1];
    genvar i;
    generate 
        for(i=0;i<FIFO_addr-1;i=i+1)
        begin
            assign wr_ptr[i] = wr_ptr[i+1] ^ wr_ptr_gr_syn[i];
        end
    endgenerate
    //empty condition
    assign empty = (wr_ptr == rd_ptr);    
endmodule
