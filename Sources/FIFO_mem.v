`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 03:03:46 AM
// Design Name: 
// Module Name: FIFO_mem
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


module FIFO_mem #(parameter FIFO_Width = 8, parameter FIFO_Depth = 16,
            parameter FIFO_addr = 5)(
    input wr_clk,
    input wr_en,
    input wr_full,
    input wr_reset,
    input [FIFO_Width-1:0] wr_data,
    input [FIFO_addr-1:0] wr_ptr,
    input rd_clk,
    input rd_en,
    input rd_reset,
    input [FIFO_addr-1:0] rd_ptr,
    output reg [FIFO_Width-1:0] rd_data
    );
    wire wr_en_s;
    reg [FIFO_Width-1:0] mem [0:FIFO_Depth-1];
    integer i;
    assign wr_en_s = wr_en & ~wr_full;
    always@(posedge wr_clk or posedge wr_reset)
    begin
        if(wr_reset)
        begin
            for(i=0;i<FIFO_Depth;i=i+1)
            begin
                mem[i] <= 0;
            end
        end
        else
        begin
            if(wr_en_s)
            begin
                mem[wr_ptr] <= wr_data;
            end
        end
    end
    always@(posedge rd_clk or posedge rd_reset)
    begin
        if(rd_reset)
        begin
            rd_data <= 0;
        end
        else
        begin
            if(rd_en)
            begin
                rd_data <= mem[rd_ptr];
            end
        end
    end
endmodule
