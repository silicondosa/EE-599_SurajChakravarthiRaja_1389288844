`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 05:52:08 PM
// Design Name: 
// Module Name: mux_2way
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


module mux_2way #(
    parameter BIT_WIDTH = 8
)
(
    input   [BIT_WIDTH-1 : 0]   in1,
    input   [BIT_WIDTH-1 : 0]   in2,
    input                       sel,
    output  [BIT_WIDTH-1 : 0]   out
);
    
    // internal wiring and registers
    wire    [BIT_WIDTH-1 : 0]   a, b;
    wire                        s;
    reg     [BIT_WIDTH-1 : 0]   o;
    
    assign a    = in1;
    assign b    = in2;
    assign s    = sel;
    assign out  = o;
    
    // RTL design of combinational MUX
    always @(a, b, s) begin
        o <= (s == 0)? a : b;
    end
endmodule
