`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 01:04:41 PM
// Design Name: 
// Module Name: adder
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

module Adder #(
    parameter BIT_WIDTH = 8
)
(
    input                       clk,
    input                       reset,
    input   [BIT_WIDTH-1 : 0]   a,
    input   [BIT_WIDTH-1 : 0]   b,
    //input                       cin,
    output  [BIT_WIDTH-1 : 0]   sum,
    //output                      cout,
    output                      valid
);

    // internal wiring and registers
    wire    [BIT_WIDTH-1 : 0]   A, B;
    reg     [BIT_WIDTH-1 : 0]   S;
    reg                         V;
    
    assign  A       = a;
    assign  B       = b;
    assign  sum     = S;
    assign  valid   = V;
    
    // RTL design for adder
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            S <= 0;
            V <= 0;
        end
        else begin
            S <= A + B;
            V <= 1;
        end
    end
    
endmodule
