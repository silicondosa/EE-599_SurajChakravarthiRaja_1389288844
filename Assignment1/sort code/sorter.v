`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2020 06:38:39 PM
// Design Name: 
// Module Name: sorter
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


module sorter #(
    parameter BIT_WIDTH = 8,
    parameter SEQ_WIDTH = 16 // this is 'n'
)
(
    input   clk,
    input   reset,
    input   start,
    input   [(BIT_WIDTH*SEQ_WIDTH)-1 : 0] in,
    output  [(BIT_WIDTH*SEQ_WIDTH)-1 : 0] out,
    output  valid
);

reg     [$clog2(SEQ_WIDTH) : 0] cycleCount;
reg                             validFlag;
reg     [BIT_WIDTH-1 : 0]       seq         [0 : SEQ_WIDTH-1];
wire    [BIT_WIDTH-1 : 0]       seq_in      [0 : SEQ_WIDTH-1];
    
    // internal wiring
    assign valid = validFlag;
    genvar i;
    generate
        for (i=0; i<SEQ_WIDTH; i = i+1) begin
            assign out[(BIT_WIDTH*i)+(BIT_WIDTH-1) : (BIT_WIDTH*i)] = seq[i];
            assign seq_in [i] = in [(BIT_WIDTH*i)+(BIT_WIDTH-1) : (BIT_WIDTH*i)];
        end
    endgenerate
    //assign seq_out = seq;

    integer mi, p, ce;
    always @ (posedge clk) begin
        if (reset == 1'b1) begin
            // reset flags
            cycleCount <= 0;
            validFlag  <= 0;
        end
        else begin // reset is LOW
            if (start == 1'b0) begin
                // copy input to internal memory and reset flags
                for(mi = 0; mi < SEQ_WIDTH; mi = mi + 1) begin
                    seq[mi] <= seq_in[mi];
                end
                cycleCount <= 0;
                validFlag  <= 0;
            end
            else begin
                // start the sorting process - do for n cycles
                if (cycleCount < SEQ_WIDTH) begin
                    //even phases
                    if (cycleCount[0] == 0) begin
                        for (p = 1; p < SEQ_WIDTH; p = p+2) begin
                            seq[p-1] <= seq[p-1] < seq[p] ? seq[p-1] : seq[p];
                            seq[p  ] <= seq[p-1] > seq[p] ? seq[p-1] : seq[p];
                        end
                    end
                    // odd phases
                    else begin
                        for (p = 2; p < SEQ_WIDTH; p = p+2) begin
                            seq[p-1] <= seq[p-1] < seq[p] ? seq[p-1] : seq[p];
                            seq[p  ] <= seq[p-1] > seq[p] ? seq[p-1] : seq[p];
                        end
                    end
                    cycleCount <= cycleCount + 1;
                end
//                else begin
//                    validFlag <= 1;
//                end
                if (cycleCount == SEQ_WIDTH-1) validFlag <= 1;
            end
        end
    end
    
endmodule
