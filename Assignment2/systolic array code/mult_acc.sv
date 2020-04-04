`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:59:32 PM
// Design Name: 
// Module Name: mult_acc
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


module mult_acc #(
    parameter BIT_WIDTH = 8
)
(
    input                           clk,
    input                           reset,
    input                           enable,
    input   [   BIT_WIDTH -1 : 0]   in1,
    input   [   BIT_WIDTH -1 : 0]   in2,
    output  [(2*BIT_WIDTH)-1 : 0]   out,
    output                          valid
);
    // internal wiring and registers
    wire    [   BIT_WIDTH -1 : 0]    A, B;
    wire                             EN;
    reg     [(2*BIT_WIDTH)-1 : 0]    C;
    reg                              V;
    
    assign  A       = in1;
    assign  B       = in2;
    assign  EN      = enable;
    assign  out     = C;
    assign  valid   = V;
    
    // RTL design for multiplier-accumulator unit
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            C <= 0;
            V <= 0;
        end
        else begin
            if (EN == 1) begin
                C <= (A * B) + C;
                V <= 1;
            end
        end
    end
endmodule
