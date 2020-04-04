`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:59:32 PM
// Design Name: 
// Module Name: systolic_cell
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


module systolic_cell #(
    parameter BIT_WIDTH = 8
)
(
    input                           clk,
    input                           reset,
    input                           en_in_a,
    input   [   BIT_WIDTH -1 : 0]   in_a,
    input                           en_in_b,
    input   [   BIT_WIDTH -1 : 0]   in_b,
    output                          en_out_a,
    output  [   BIT_WIDTH -1 : 0]   out_a,
    output                          en_out_b,
    output  [   BIT_WIDTH -1 : 0]   out_b,
    output  [(2*BIT_WIDTH)-1 : 0]   out_c,
    output                          valid
);
    
    // internal wiring + registers
    wire                             en;
    wire    [   BIT_WIDTH -1 : 0]    A, B;
    wire    [(2*BIT_WIDTH)-1 : 0]    C;
    wire                             V;
    reg                              en_a_reg, en_b_reg;
    reg     [   BIT_WIDTH -1 : 0]    A_reg, B_reg;
    
    assign A        = in_a;
    assign B        = in_b;
    assign out_c    = C;
    assign valid    = V;
    assign en_out_a = en_a_reg;
    assign out_a    = A_reg;
    assign en_out_b = en_b_reg;
    assign out_b    = B_reg;
    
    assign en       = en_in_a & en_in_b;
    
    // connect mult_acc unit
    mult_acc #(.BIT_WIDTH(BIT_WIDTH))
        MAC (
            .clk    (clk),
            .reset  (reset),
            .enable (en),
            .in1    (A),
            .in2    (B),
            .out    (C),
            .valid  (V)
    );
    
    // registered bypass connectivity of systolic cell
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            en_a_reg <= 0;
            A_reg    <= 0;
            en_b_reg <= 0;
            B_reg    <= 0;
        end
        else begin
            en_a_reg <= en_in_a;
            A_reg <= A;
            en_b_reg <= en_in_b;
            B_reg <= B;
        end
    end
    
endmodule
