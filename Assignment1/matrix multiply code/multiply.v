`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2020 02:18:28 PM
// Design Name: 
// Module Name: multiply
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


module Multiply #(
    parameter BIT_WIDTH = 8
)
(
    input                           clk,
    input                           reset,
    input   [   BIT_WIDTH -1 : 0]   in1,
    input   [   BIT_WIDTH -1 : 0]   in2,
    output  [(2*BIT_WIDTH)-1 : 0]   pdt,
    output                          valid
);
    // internal wiring and registers
    wire    [   BIT_WIDTH -1 : 0]    A, B;
    reg     [(2*BIT_WIDTH)-1 : 0]    P;
    reg                              V;
    
    assign  A       = in1;
    assign  B       = in2;
    assign  pdt     = P;
    assign  valid   = V;
    
    // RTL design for multiplier
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            P <= 0;
            V <= 0;
        end
        else begin
            P <= A * B;
            V <= 1;
        end
    end
     
endmodule
