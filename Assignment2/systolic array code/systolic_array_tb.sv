`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2020 12:28:00 AM
// Design Name: 
// Module Name: systolic_array_tb
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


module systolic_array_tb #(
    parameter   BIT_WIDTH = 8,
    parameter   NUM_ROWS  = 16,
    parameter   NUM_COLS  = NUM_ROWS,
    localparam  LINES     = NUM_ROWS + NUM_COLS - 1,
    localparam  NUM_RANGE = 10//(2**BIT_WIDTH)
)
(
);
    reg                           clk;
    reg                           reset;
    reg                           en_in_a;
    reg   [   BIT_WIDTH -1 : 0]   in_a    [0 : NUM_ROWS-1];
    reg                           en_in_b;
    reg   [   BIT_WIDTH -1 : 0]   in_b    [0 : NUM_COLS-1];
    wire  [(2*BIT_WIDTH)-1 : 0]   out_c   [0 : NUM_ROWS-1]    [0 : NUM_COLS-1];
    wire                          valid;
    
    reg   [(  BIT_WIDTH)-1 : 0]   A       [0 : NUM_ROWS-1]    [0 : NUM_COLS-1];
    reg   [(  BIT_WIDTH)-1 : 0]   B       [0 : NUM_ROWS-1]    [0 : NUM_COLS-1];

    // test setup
    integer i,j,k;
    initial begin
        $display("\n");
        $display("--------------------------------------------");
        $display("Matrix multiplication using systolic arrays:");
        $display("--------------------------------------------");
        // generate and display A matrices
        $display("\nA matrix:");
        for (i = 0; i < NUM_ROWS; i = i+1) begin
            for (j = 0; j < NUM_COLS; j = j+1) begin
                A[i][j] = $urandom_range(0, NUM_RANGE-1);
                $write("[%d] ", A[i][j]);
            end
            $display(" ");
        end
        $display("\n");
        
        // generate and display A matrices
        $display("\nB matrix:");
        for (i = 0; i < NUM_ROWS; i = i+1) begin
            for (j = 0; j < NUM_COLS; j = j+1) begin
                B[i][j] = $urandom_range(0, NUM_RANGE-1);
                $write("[%d] ", B[i][j]);
            end
            $display(" ");
        end
        $display("\n");
        
        // setup monitoring
        $display("Time: CLK RESET | EN_IN_A EN_IN_B | VALID");
        $monitor("%g:\t%b\t%b | %b\t%b | %b", $time, clk, reset, en_in_a, en_in_b, valid);
        
        // initial values
        clk     = 1;
        reset   = 1;
        
        // clear reset
        #5 reset = 0;
        
        // finish
        #1000 $finish;
    end
    
    // input scheduling
    integer   a_l,   b_l;
    integer col_a, row_a;
    integer col_b, row_b;
    always @(posedge clk) begin
        if (reset == 1'b0) begin
            // Input A scheduling
            if (a_l < LINES) begin
                en_in_a = 1;
                col_a =  (a_l < NUM_COLS-1)? a_l : NUM_COLS-1; // start col
                row_a = ((a_l > NUM_COLS-1)? a_l : NUM_COLS-1) - (NUM_COLS-1); // start row
                $write("\nA input %d:",a_l);
                for (i = 0; i < NUM_ROWS; i = i+1) begin
                    if (col_a >= 0 && row_a < NUM_ROWS) begin
                        if(row_a == i) begin
                            in_a[i] = A[row_a][col_a];
                            row_a   = row_a + 1;
                            col_a   = col_a - 1;
                        end
                        else begin
                            in_a[i] = 0;
                        end
                    end
                    else begin
                        in_a[i] = 0;
                    end
                    $write(" [%d]", in_a[i]);
                end // input line filling loop
                a_l = a_l + 1;
            end
            else begin
                en_in_a = 0;
            end
            
            // Input B scheduling
            if (b_l < LINES) begin
                en_in_b = 1;
                row_b =  (b_l < NUM_ROWS-1)? b_l : NUM_ROWS-1; // start col
                col_b = ((b_l > NUM_ROWS-1)? b_l : NUM_ROWS-1) - (NUM_ROWS-1); // start row
                $write("\nB input %d:",b_l);
                for (i = 0; i < NUM_COLS; i = i+1) begin
                    if (row_b >= 0 && col_b < NUM_COLS) begin
                        if(col_b == i) begin
                            in_b[i] = B[row_b][col_b];
                            row_b   = row_b - 1;
                            col_b   = col_b + 1;
                        end
                        else begin
                            in_b[i] = 0;
                        end
                    end
                    else begin
                        in_b[i] = 0;
                    end
                    $write(" [%d]", in_b[i]);
                end // input line filling loop
                $display("\n");
                b_l = b_l + 1;
            end
            else begin
                en_in_b = 0;
            end
            
        end
        else begin
            a_l <= 0;
            b_l <= 0;
        end
    end
    
    // dispaly result to out_c matrix
    integer ii, jj;
    always @(posedge valid) begin
        if (reset == 1'b0 && valid == 1'b1) begin
            $display("\nResultant product matrix [C = A*B]:");
            for (ii = 0; ii < NUM_ROWS; ii = ii+1) begin
                for (jj = 0; jj < NUM_COLS; jj = jj+1) begin
                    $write("[%d] ", out_c[ii][jj]);
                end
                $display("");
            end
            $display("");
            #10 $finish;
        end
    end
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // DUT instantiation
    systolic_array_top #(
            .BIT_WIDTH(BIT_WIDTH),
            .NUM_ROWS(NUM_ROWS)
        )
        DUT (
            .clk        (clk),
            .reset      (reset),
            .en_in_a    (en_in_a),
            .in_a       (in_a),
            .en_in_b    (en_in_b),
            .in_b       (in_b),
            .out_c      (out_c),
            .valid      (valid)
    );
    
endmodule
