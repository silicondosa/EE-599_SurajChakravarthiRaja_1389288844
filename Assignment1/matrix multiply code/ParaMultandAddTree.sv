`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2020 10:50:07 PM
// Design Name: 
// Module Name: ParaMultandAddTree
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


module ParaMultandAddTree #(
    parameter BIT_WIDTH   = 8,
    parameter STAGE_WIDTH = 4,
    parameter NUM_PARA    = 43
)
(
    input   clk,
    input   reset,
    input   [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] a [0:NUM_PARA-1],
    input   [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] b [0:NUM_PARA-1],
    output  [          (2*BIT_WIDTH)-1 : 0] c [0:NUM_PARA-1], // c is double bit-width since mult produces double width output
    output                              valid [0:NUM_PARA-1]
);
    
    genvar i;
    generate
        for (i = 0; i < NUM_PARA; i = i+1) begin: PMAC
            MulandAddTree #(.BIT_WIDTH(BIT_WIDTH), .STAGE_WIDTH(STAGE_WIDTH))
                PE (
                    .clk(clk),
                    .reset(reset),
                    .a(a[i]),
                    .b(b[i]),
                    .c(c[i]),
                    .valid(valid[i])
                );
        end
    endgenerate
endmodule
