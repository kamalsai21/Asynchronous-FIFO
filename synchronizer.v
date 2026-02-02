`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2026 02:01:12 AM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer #(width = 5)(
    input [width-1:0] data_in,
    input clk,
    input reset,
    output reg [width-1:0] data_out
    );
    reg [width-1:0] sync0;
    always@(posedge clk)
    begin
        if(reset)
        begin
            sync0 <= 0;
            data_out <= 0;
        end
        else
        begin
            sync0 <= data_in;
            data_out <= sync0;
        end
    end
endmodule
