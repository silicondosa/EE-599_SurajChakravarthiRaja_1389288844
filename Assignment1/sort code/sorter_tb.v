`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2020 10:26:19 PM
// Design Name: 
// Module Name: sorter_tb
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


module sorter_tb #(
    parameter BIT_WIDTH = 8,
    parameter SEQ_WIDTH = 16 // this is 'n'
)
(
);

    reg     clk;
    reg     reset;
    reg     start;
    reg     [BIT_WIDTH-1 : 0]               seq     [0 : SEQ_WIDTH-1];
    wire    [(BIT_WIDTH*SEQ_WIDTH)-1 : 0]   in;
    wire    [(BIT_WIDTH*SEQ_WIDTH)-1 : 0]   out;
    wire    [BIT_WIDTH-1 : 0]               newSeq  [0 : SEQ_WIDTH-1];
    wire     valid;
    
    // internal wiring - map 1D to 2D
    genvar m;
    generate
        for ( m = 0; m < SEQ_WIDTH; m = m+1) begin
            assign in[(BIT_WIDTH*m)+(BIT_WIDTH-1) : BIT_WIDTH*m]    = seq [m];
            assign newSeq [m]                                       = out[(BIT_WIDTH*m)+(BIT_WIDTH-1) : BIT_WIDTH*m];
        end
    endgenerate
    
    // test setup
    integer i;
    initial begin
        
        $display("\nOdd-Even Transposition Sort Testbench");
        // generate random data and store as sequence
//        seq[0] = 3; seq[1] = 2; seq[2] = 3; seq[3] = 8;
//        seq[4] = 5; seq[5] = 6; seq[6] = 4; seq[7] = 1;
        $display("\nInput sequence:");
        for (i = 0; i < SEQ_WIDTH; i = i+ 1) begin
            seq[i] = $urandom % 10;
            $display("seq[%d]: %d", i, seq[i]); 
        end
        $display(" ");
        
        // start TCL monitor
        $display("Time \t CLK RESET START VALID");
        $monitor("%g\t %b   %b  %b  %b", $time, clk, reset, start, valid);
        
        // initial values
        clk = 1;
        reset = 1;
        start = 0;
        
        // clear reset
        #5 reset = 0;
        
        // start sorting
        #15 start = 1;
        
        // display sorted array
        $display("\nSorted sequence:");
        for (i = 0; i < SEQ_WIDTH; i = i+ 1) begin
            $display("newSeq[%d]: %d", i, seq[i]); 
        end
        
        //stop sim after a while
        //#180 $finish;
    end
    
    //stop sim when we see valid line go HIGH
    always @(posedge clk) begin
        if (valid == 1) begin
            #20 $finish;
        end
    end
    
    // clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // DUT
    sorter #(.BIT_WIDTH(BIT_WIDTH), .SEQ_WIDTH(SEQ_WIDTH))
        DUT (
            .clk    (clk),
            .reset  (reset),
            .start  (start),
            .in     (in),
            .out    (out),
            .valid  (valid)
        );
    
endmodule
