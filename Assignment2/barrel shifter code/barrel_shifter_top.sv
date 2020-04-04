`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 05:52:08 PM
// Design Name: 
// Module Name: barrel_shifter_top
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


module barrel_shifter_top #(
    parameter   BIT_WIDTH   = 8,
    parameter   STAGE_WIDTH = 16,
    localparam  STAGE_DEPTH = $clog2(STAGE_WIDTH)
)
(
    input                         clk,
    input                         reset,
    input                         valid_in,
    input   [  BIT_WIDTH-1 : 0]   in  [0 : STAGE_WIDTH-1],
    input   [STAGE_DEPTH-1 : 0]   sel,
    output                        valid_out,
    output  [  BIT_WIDTH-1 : 0]   out [0 : STAGE_WIDTH-1]
);
    
    // stage wiring
    wire    [  BIT_WIDTH-1 : 0]   f     [0 : STAGE_DEPTH-1] [0 : STAGE_WIDTH-1];
    wire    [STAGE_DEPTH-1 : 0]   s     [0 : STAGE_DEPTH-1];
    wire    [  BIT_WIDTH-1 : 0]   g     [0 : STAGE_DEPTH-1] [0 : STAGE_WIDTH-1];
    wire                          v     [0 : STAGE_DEPTH-1];
    
    // stage registers
    reg     [STAGE_DEPTH-1 : 0]   s_reg [0 : STAGE_DEPTH-1];
    reg                           v_reg [0 : STAGE_DEPTH-1];
    reg     [  BIT_WIDTH-1 : 0]   g_reg [0 : STAGE_DEPTH-1] [0 : STAGE_WIDTH-1];
    
    // wire module inputs
    assign f[0]         = in;
    assign s[0]         = sel;
    assign v[0]         = valid_in;
    
    // wire module outputs
    assign out          = g_reg [STAGE_DEPTH-1];
    assign valid_out    = v_reg [STAGE_DEPTH-1];
    
    // wire combinational lines (input and select and internal valid lines) at each stage (except first stage)
    genvar i,j;
    generate
        for (i = 1; i < STAGE_DEPTH; i = i+1) begin
            assign f[i] = g_reg[i-1];
            assign v[i] = v_reg[i-1];
            for (j = i; j < STAGE_DEPTH; j = j+1) begin
                assign s[i][j] = s_reg[i-1][j];
            end
        end
    endgenerate
    
    // generate butterfly stage logic
    generate
        for (i = 0; i < STAGE_DEPTH; i = i+1) begin : SHIFT_STAGE
            butterfly_mux_stage #( .BIT_WIDTH(BIT_WIDTH), .STAGE_WIDTH(STAGE_WIDTH), .STAGE_POS(i) )
                BMS(
                    .in(f[i]),
                    .sel(s[i][i]),
                    .out(g[i])
            );
        end
    endgenerate    
    
    // RTL design for barrel shifter
    reg [STAGE_DEPTH+1 : 0] ii, jj, kk;
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            for (ii = 0; ii < STAGE_DEPTH; ii = ii+1) begin
                v_reg[ii] <= 0;
                
                for (jj = 0; jj < STAGE_WIDTH; jj = jj+1) begin
                    g_reg[ii][jj] <= 0;
                end
                for (kk = ii+1; kk < STAGE_DEPTH; kk = kk+1) begin
                    s_reg[ii][kk] <= 0;
                end
                
            end // end ii loop
        end // end if block
        else begin
            //SCR - put connections here
            v_reg <= v;
            g_reg <= g;
            for (ii = 0; ii < STAGE_DEPTH; ii = ii+1) begin
//                if (ii == 0) begin
//                    v_reg[ii] <= valid_in;
//                end
//                else begin
//                    v_reg[ii] <= v_reg[ii-1];
//                end
                for (kk = ii+1; kk < STAGE_DEPTH; kk = kk+1) begin
                    s_reg[ii][kk] <= s[ii][kk];
                end
            end
        end // end else block
    end // end always block
    
endmodule
