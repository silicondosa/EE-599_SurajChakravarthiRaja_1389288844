`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 05:24:12 PM
// Design Name: 
// Module Name: MulandAddTree
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


module MulandAddTree #(
    parameter BIT_WIDTH = 8,
    parameter STAGE_WIDTH = 4
)
(
    input                                   clk,
    input                                   reset,
//    input   [BIT_WIDTH-1 : 0]   a[STAGE_WIDTH-1 : 0],
//    input   [BIT_WIDTH-1 : 0]   b[STAGE_WIDTH-1 : 0],
    input   [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] a,
    input   [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] b,
  //  input [BIT_WIDTH-1 : 0]   c   [STAGE_WIDTH-1 : 0],
    output  [         (2*BIT_WIDTH) -1 : 0] c, // c is double bit-width since mult produces double width output
    output                                  valid
);

    wire    [   BIT_WIDTH -1 : 0]   A   [0 : STAGE_WIDTH-1];
    wire    [   BIT_WIDTH -1 : 0]   B   [0 : STAGE_WIDTH-1];
    wire    [(2*BIT_WIDTH)-1 : 0]   P   [0 : STAGE_WIDTH-1]; // P is double bit-width since mult produces double width output
    wire    [(2*BIT_WIDTH)-1 : 0]   C; // C is double bit-width since mult produces double width output
    
    // map 1D inputs into 2D arrays for ingestion
    genvar mi;
    generate
        for (mi=0; mi<STAGE_WIDTH; mi = mi+1) begin
            assign A[mi] = a[(BIT_WIDTH*mi)+(BIT_WIDTH-1) : (BIT_WIDTH*mi)];
            assign B[mi] = b[(BIT_WIDTH*mi)+(BIT_WIDTH-1) : (BIT_WIDTH*mi)];
        end
    endgenerate
    assign c = C;
    
    //-------------
    //MULT-ADD Tree
    //-------------
    wire [(2*BIT_WIDTH)-1 : 0]  sbus   [$clog2(STAGE_WIDTH) : 0] [0 : STAGE_WIDTH-1]; // sbus double bit-width since mult produces double width output
    wire                        vbit   [$clog2(STAGE_WIDTH) : 0] [0 : STAGE_WIDTH-1];

    // generate multiplier stage
    genvar i;
    generate
        for (i = 0; i < STAGE_WIDTH; i = i + 1) begin : MULT_STAGE
            Multiply #( .BIT_WIDTH(BIT_WIDTH) )
                PDT (
                    .clk    (clk),
                    .reset  (reset),
                    .in1    (A[i]),
                    .in2    (B[i]),
                    .pdt    (sbus[0][i]), // sbus double bit-width since mult produces double width output
                    .valid  (vbit[0][i]) 
                );
        end
    endgenerate
    
    // generate adder tree
    genvar r;
    generate
        integer h = $clog2(STAGE_WIDTH);
        for (r = 1; r <= $clog2(STAGE_WIDTH); r = r + 1) begin : ADDER_TREE
            //#adders per stage = 2^(h-r)
            for (i = 0; i < 2**($clog2(STAGE_WIDTH)-r); i = i + 1) begin : ADDER_STAGE
                // generate 2^(h-r) adders in the r-th stage
                Adder #( .BIT_WIDTH(2*BIT_WIDTH) ) // double bit-width for adder since mult output is double width
                    SUM (
                        .clk    (clk),
                        .reset  (~(vbit[r-1] [((2**r)*i)           ] &  vbit [r-1] [((2**r)*i) + (2**(r-1))]) ),
                        .a      ( sbus [r-1] [((2**r)*i)             ] ),
                        .b      ( sbus [r-1] [((2**r)*i) + (2**(r-1))] ),
                        .sum    ( sbus [ r ] [((2**r)*i)             ] ),
                        .valid  ( vbit [ r ] [((2**r)*i)             ] )
                    );
            end
        end
    endgenerate
    
    // connect mult-add tree output to module output
    assign C        = sbus[$clog2(STAGE_WIDTH)][0];
    assign valid    = vbit[$clog2(STAGE_WIDTH)][0];
    
endmodule
