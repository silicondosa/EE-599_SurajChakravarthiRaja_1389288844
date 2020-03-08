`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2020 12:50:01 AM
// Design Name: 
// Module Name: MulandAddTree_tb
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


module MulandAddTree_tb#(
    parameter BIT_WIDTH = 8,
    parameter STAGE_WIDTH = 4
)
(
);

    reg clk;
    reg reset;
    wire [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] a;
    wire [(STAGE_WIDTH*BIT_WIDTH)-1 : 0] b;
    reg     [   BIT_WIDTH -1 : 0]   A   [0 : STAGE_WIDTH-1];
    reg     [   BIT_WIDTH -1 : 0]   B   [0 : STAGE_WIDTH-1];
    wire    [(2*BIT_WIDTH)-1 : 0]   c; // C is double bit-width since mult produces double width output
    wire                        valid;
    
    reg     [   BIT_WIDTH -1 : 0]   AA  [0 : STAGE_WIDTH-1] [0 : STAGE_WIDTH-1];
    reg     [   BIT_WIDTH -1 : 0]   BB  [0 : STAGE_WIDTH-1] [0 : STAGE_WIDTH-1];
    reg     [(2*BIT_WIDTH)-1 : 0]   CC  [0 : STAGE_WIDTH-1] [0 : STAGE_WIDTH-1]; // CC is double bit-width since mult produces double width output
    
    // map 1D to 2D wiring
    genvar mi;
    generate
        for ( mi = 0; mi < STAGE_WIDTH; mi = mi+1) begin
            assign a[(BIT_WIDTH*mi)+(BIT_WIDTH-1) : (BIT_WIDTH*mi)] = A[mi];
            assign b[(BIT_WIDTH*mi)+(BIT_WIDTH-1) : (BIT_WIDTH*mi)] = B[mi];
        end
    endgenerate
    
    // Test setup
    integer seed, i, j, k;
    initial begin
        $display("Odd-Even Transposition Sort Testbench");
        $display("Time \t CLK RESET VALID");
        $monitor("%g\t %b   %b  %b", $time, clk, reset, valid);
        
        // initial values
        clk = 1;
        reset = 1;
                
        // generate  and display input data
        $display("\nAA matrix:");
        for (i = 0; i < STAGE_WIDTH; i = i+ 1) begin
            for (j = 0; j < STAGE_WIDTH; j = j+1) begin
                AA[i][j] = $urandom%10;
                BB[i][j] = $urandom%10;
                $write("[%d] ", AA[i][j]);
            end
            $display(" ");
        end
        $display(" ");
        
        $display("\nBB matrix:");
        for (i = 0; i < STAGE_WIDTH; i = i+ 1) begin
            for (j = 0; j < STAGE_WIDTH; j = j+1) begin
                BB[i][j] = $urandom%10;
                $write("[%d] ", BB[i][j]);
            end
            $display(" ");
        end
        $display(" ");
        
        // clear reset
        #15 reset = 0;
        
        // send input arrays to DUT at every 10 sim steps
        for (i = 0; i < STAGE_WIDTH; i = i+ 1) begin
            for (j = 0; j < STAGE_WIDTH; j = j+1) begin
                for (k = 0; k < STAGE_WIDTH; k = k+1) begin
                    A[k] = AA[i][k];
                    B[k] = BB[k][j];
                    //$display("i=%d | j=%d | k=%d", i, j, k);
                end
                #10; // send data at every 10 steps
            end
        end
        
        // reset circuit
        reset = 1;
         
        // reset circuit and view matrix-matrix product
        #50 // reset = 1;
        
        // Display output matrix in tcl console 
        $display("\nCC matrix:");
        for (i = 0; i < STAGE_WIDTH; i = i+ 1) begin
            for (j = 0; j < STAGE_WIDTH; j = j+1) begin
                $write("[%d] ", CC[i][j]);
            end
            $display(" ");
        end
        $display(" ");
        
        #5 $finish;
    end // end initial block
    
    // clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // send input to DUT
    // send input arrays to DUT at every clock
//    integer u, v, w;
//    always @(posedge clk) begin
//        if (reset == 1'b0) begin 
//            for (u = 0; u < STAGE_WIDTH; u = v+1) begin
//                for (v = 0; v < STAGE_WIDTH; v = v+1) begin
//                    for (w = 0; w < STAGE_WIDTH; w = w+1) begin
//                        A[w] = AA[u][w];
//                        B[w] = BB[w][v];
//                        $display("i=%d | j=%d | k=%d", i, j, k);
//                    end
//                end
//            end
//        end
//    end
    
    // Copy result to CC matrix
    integer idx, idy;
    always @(posedge clk) begin
        if (valid == 1'b1) begin
            CC[idx][idy] <= c;
            if (idy == STAGE_WIDTH-1) begin
                idy <= 0;
                if (idx == STAGE_WIDTH-1) idx <= 0;
                    else idx <= idx + 1;
            end
            else idy <= idy + 1;
            
        end
        else begin
            idx <= 0;
            idy <= 0;
        end
    end
    
    // Instantiate design under test
    MulandAddTree #(.BIT_WIDTH(BIT_WIDTH), .STAGE_WIDTH(STAGE_WIDTH))
        DUT (
            .clk(clk),
            .reset(reset),
            .a(a),
            .b(b),
            .c(c),
            .valid(valid)
        );
    
endmodule
