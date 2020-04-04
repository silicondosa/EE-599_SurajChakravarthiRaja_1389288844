`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2020 11:53:11 PM
// Design Name: 
// Module Name: mult_acc_tb
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


module mult_acc_tb #(
    parameter   BIT_WIDTH = 8,
    localparam  NUM_RANGE = 10//(2**BIT_WIDTH)
)
(
);
    reg                     clk;
    reg                     reset;
    reg                     en;
    reg  [   BIT_WIDTH -1:0] A;
    reg  [   BIT_WIDTH -1:0] B;
    wire [(2*BIT_WIDTH)-1:0] C;
    wire                    valid;
    
    initial begin
        $display("Time: CLK RESET EN | A B C | VALID");
        $monitor ("%g:\t%b\t%b\t%b | %d\t%d\t%d | %b", $time, clk, reset, en, A, B, C, valid);
        
        // Initial values
        clk     = 1;
        reset   = 1;
        en      = 0;
        A       = 0;
        B       = 0;
        
        // Clear reset line
        #5 reset   = 0;
        
        // enable mult_acc
        #10 en = 1;
        
        // disable mult_acc unit
        #50 en = 0;
        
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
    always @(negedge clk) begin
        if (reset == 1'b0 && en == 1) begin
            A = $urandom_range(0, NUM_RANGE-1);
            B = $urandom_range(0, NUM_RANGE-1);
            $write("\nA: [%d]\tB: [%d]\n\n", A, B);
        end
    end
    
    mult_acc #(
        .BIT_WIDTH(BIT_WIDTH)
    )
    DUT (
        .clk(clk),
        .reset(reset),
        .enable(en),
        .in1(A),
        .in2(B),
        .out(C),
        .valid(valid)
    );
    
endmodule
