`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2020 01:36:08 PM
// Design Name: 
// Module Name: barrel_shifter_tb
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


module barrel_shifter_tb #(
    parameter   BIT_WIDTH = 8,
    parameter   STAGE_WIDTH = 16,
    localparam  STAGE_DEPTH = $clog2(STAGE_WIDTH),
    localparam  NUM_INPUTS  = 3
)
(
);
    // Wiring and registers
    reg                         clk;
    reg                         reset;
    reg                         valid_in;
    reg [  BIT_WIDTH-1 : 0]     in          [0 : STAGE_WIDTH-1];
    reg [STAGE_DEPTH-1 : 0]     r;
    reg                         valid_out;
    reg [  BIT_WIDTH-1 : 0]     out         [0 : STAGE_WIDTH-1];
    
    // Instantiate Design Under Test
    barrel_shifter_top #(.BIT_WIDTH(BIT_WIDTH), .STAGE_WIDTH(STAGE_WIDTH))
        DUT (
            .clk(clk),
            .reset(reset),
            .valid_in(valid_in),
            .in(in),
            .sel(r),
            .valid_out(valid_out),
            .out(out)
    );
    
    // Probing setup
    integer i;
    initial begin
        $display("Barrel shifter testbench");
        $display("Time \t CLK RESET VALID");
        $monitor("%g: %b\t%b\t|\t%b - %b", $time, clk, reset, valid_in, valid_out);
        
        // initial values
        clk = 1;
        reset = 1;
        valid_in = 0;
        
        // generate and display input data
//        $display("\nInput values:");
//        for (i = 0; i < STAGE_WIDTH; i = i + 1) begin
//            in[i] = $urandom_range(0, (2**BIT_WIDTH)-1);
//            $write("[%d] ", in[i]);
//        end
//        $display(" ");
        
//        r = $urandom_range(1, STAGE_WIDTH-1);
//        $write("Rotating input by [%d] places\n", r);

        // clear reset and make input valid
        #15  reset    = 0;
        //#5  valid_in = 1;

         
        // reset circuit and view matrix-matrix product
        // #50 reset = 1;
        

        #500 $finish; // worst-case stop 
    end // end initial block
    
    // Generate and display input data
    reg [STAGE_DEPTH : 0] ii, kk;
    always @(posedge clk) begin
        if (reset == 0) begin
            if (kk < NUM_INPUTS) begin
                r = $urandom_range(1, STAGE_WIDTH-1);
                $write("Rotating the following input by [%d] places\n", r);
                for (ii = 0; ii < STAGE_WIDTH; ii = ii + 1) begin
                    in[ii] = $urandom_range(0, (2**BIT_WIDTH)-1);
                    $write("[%d] ", in[ii]);
                end
                $display(" ");
                kk <= kk + 1;
                valid_in <= 1;
            end
            else begin
                valid_in <= 0;
            end
        end
        else begin
            kk <= 0;
        end
    end
    
    // Display barrel shifted output
    reg [STAGE_DEPTH : 0] jj;
    always @(posedge clk) begin
        if (reset == 0) begin
            if (jj < NUM_INPUTS && valid_out == 1) begin
                $display("\nNew set of valid output values:");
                for (i = 0; i < STAGE_WIDTH; i = i+ 1) begin
                    $write("[%d] ", out[i]);
                end
                $display(" ");
                jj <= jj + 1;
                if (jj == NUM_INPUTS-1) begin
                    #5 reset = 1;
                    #5 $finish;
                end
            end
        end
        else begin
            jj <= 0;
        end
    end
    
    // clock generation
    always begin
        #5 clk = ~clk;
    end
    


endmodule
