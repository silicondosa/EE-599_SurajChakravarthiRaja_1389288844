`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 05:52:08 PM
// Design Name: 
// Module Name: butterfly_mux_stage
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


module butterfly_mux_stage #(
    parameter BIT_WIDTH     = 8,
    parameter STAGE_WIDTH   = 16,
    parameter STAGE_POS     = 4,
    localparam STAGE_ROT    = (2**STAGE_POS)
)
(
    input   [BIT_WIDTH-1 : 0]   in  [0 : STAGE_WIDTH-1],
    input                       sel,
    output  [BIT_WIDTH-1 : 0]   out [0 : STAGE_WIDTH-1]
);
    // input wiring and registers
    wire    [BIT_WIDTH-1 : 0]   f   [0 : STAGE_WIDTH-1];
    wire                        s;
    reg     [BIT_WIDTH-1 : 0]   g   [0 : STAGE_WIDTH-1];
    
    assign f    = in;
    assign s    = sel;
    assign out  = g;
    
    //generate and connect combinational multiplexers
    genvar i;
    generate
        for (i = 0; i < STAGE_WIDTH; i = i+1) begin : STAGE_MUX
            integer j = ( (i-STAGE_ROT) < 0)? STAGE_WIDTH+(i-STAGE_ROT): (i-STAGE_ROT);
            mux_2way #( .BIT_WIDTH(BIT_WIDTH) )
            mux (
                .in1(f[i]),
                .in2(f[j]),
                .sel(s),
                .out(g[i])
             );
        end
    endgenerate
endmodule
