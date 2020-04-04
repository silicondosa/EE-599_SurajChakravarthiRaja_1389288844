`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 01:07:44 AM
// Design Name: 
// Module Name: systolic_cell_tb
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


module systolic_cell_tb #(
    parameter   BIT_WIDTH = 8,
    localparam  NUM_RANGE = 10//(2**BIT_WIDTH)
)
(
);
    reg                      clk;
    reg                      reset;
    reg                      en_in_a;
    reg  [   BIT_WIDTH -1:0] in_A;
    reg                      en_in_b;
    reg  [   BIT_WIDTH -1:0] in_B;
    wire                     en_out_a;
    wire [   BIT_WIDTH -1:0] out_A;
    wire                     en_out_b;
    wire [   BIT_WIDTH -1:0] out_B;
    wire [(2*BIT_WIDTH)-1:0] out_C;
    wire                     valid;
    
    initial begin
        $display("Time: CLK RESET | EN_IN_A IN_A | EN_IN_B IN_B | EN_OUT_A EN_OUT_B | C VALID");
        $monitor("%g:\t%b\t%b | %b\t%d | %b\t%d | %b\t%b | %d\t%b", $time, clk, reset, en_in_a, en_in_b, in_A, in_B, en_out_a, en_out_b, out_C, valid);
        
        // Initial values
        clk     = 1;
        reset   = 1;
        en_in_a = 0;
        en_in_b = 0;
        in_A    = 0;
        in_B    = 0;
        
        // Clear reset line
        #5 reset   = 0;
        
        // enable mult_acc
        #5 en_in_a = 1;
        #10 en_in_b = 1;
        
        // disable mult_acc unit
        #50 en_in_a = 0;
            en_in_b = 0;
        
        // reset circuit
        #10 reset = 1;
        // finish simulation
        #5 $finish;
    end
    
    // Clock generation
    always begin
        #5 clk = ~clk;
    end
    
    // input generation
    always @(posedge clk) begin
        if (reset == 1'b0 && en_in_a == 1 && en_in_b == 1) begin
            in_A = $urandom_range(0, NUM_RANGE-1);
            in_B = $urandom_range(0, NUM_RANGE-1);
            $write("\nIN_A: [%d]\tIN_B: [%d]\n\n", in_A, in_B);
        end
    end
    
    systolic_cell #(
        .BIT_WIDTH(BIT_WIDTH)
    )
    DUT (
        .clk        (clk),
        .reset      (reset),
        .en_in_a    (en_in_a),
        .in_a       (in_A),
        .en_in_b    (en_in_b),
        .in_b       (in_B),
        .en_out_a   (en_out_a),
        .out_a      (out_A),
        .en_out_b   (en_out_b),
        .out_b      (out_B),
        .out_c      (out_C),
        .valid      (valid)
    );
    
endmodule
