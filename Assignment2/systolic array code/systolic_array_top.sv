`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:59:32 PM
// Design Name: 
// Module Name: systolic_array_top
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


module systolic_array_top #(
    parameter BIT_WIDTH = 8,
    parameter NUM_ROWS  = 16,
    parameter NUM_COLS  = NUM_ROWS
)
(
    input                           clk,
    input                           reset,
    input                           en_in_a,
    input   [   BIT_WIDTH -1 : 0]   in_a    [0 : NUM_ROWS-1],
    input                           en_in_b,
    input   [   BIT_WIDTH -1 : 0]   in_b    [0 : NUM_COLS-1],
    output  [(2*BIT_WIDTH)-1 : 0]   out_c   [0 : NUM_ROWS-1]    [0 : NUM_COLS-1],
    output                          valid   
);
    
    // inter-cell link wiring
    wire                            lnk_en_a[0 : NUM_ROWS-1]    [0 : NUM_COLS  ];
    wire    [   BIT_WIDTH -1 : 0]   lnk_a   [0 : NUM_ROWS-1]    [0 : NUM_COLS  ];
    
    wire                            lnk_en_b[0 : NUM_ROWS  ]    [0 : NUM_COLS-1];
    wire    [   BIT_WIDTH -1 : 0]   lnk_b   [0 : NUM_ROWS  ]    [0 : NUM_COLS-1];
    
    wire                            lnk_val [0 : NUM_ROWS-1]    [0 : NUM_COLS-1];
    
    // connect module inputs to link wiring 
    genvar i;
    generate
        // first column linking  (enable and input for A)
        for (i = 0; i < NUM_ROWS; i = i + 1) begin
            assign lnk_a   [i][0] = in_a[i];
            assign lnk_en_a[i][0] = en_in_a;
        end
        // first row linking (enable and input for B)
        for (i = 0; i < NUM_COLS; i = i + 1) begin
            assign lnk_b   [0][i] = in_b[i];
            assign lnk_en_b[0][i] = en_in_b;
        end
    endgenerate
    
    // connect module's output valid line to valid line of last cell in the array 
    //assign valid = (lnk_val[NUM_ROWS-1][NUM_COLS-1]) & (~lnk_en_b[NUM_ROWS][NUM_COLS-1]) & (~lnk_en_a[NUM_ROWS-1][NUM_COLS]);
    assign valid = (lnk_val[NUM_ROWS-1][NUM_COLS-1]) & (~lnk_en_b[NUM_ROWS-1][NUM_COLS-1]) & (~lnk_en_a[NUM_ROWS-1][NUM_COLS-1]);
    
    // generate systolic cell matrix and connect to link wiring
    genvar j;
    generate
        for (i = 0; i < NUM_ROWS; i = i + 1) begin : SA_row
            for (j = 0; j < NUM_COLS; j = j + 1) begin : SA_col
                systolic_cell #(.BIT_WIDTH(BIT_WIDTH))
                    PE (
                        .clk        (clk),
                        .reset      (reset),
                        .en_in_a    (lnk_en_a[i  ] [j  ]),
                        .in_a       (lnk_a   [i  ] [j  ]),
                        .en_in_b    (lnk_en_b[i  ] [j  ]),
                        .in_b       (lnk_b   [i  ] [j  ]),
                        .en_out_a   (lnk_en_a[i  ] [j+1]),
                        .out_a      (lnk_a   [i  ] [j+1]),
                        .en_out_b   (lnk_en_b[i+1] [j  ]),
                        .out_b      (lnk_b   [i+1] [j  ]),
                        .out_c      (out_c   [i  ] [j  ]),
                        .valid      (lnk_val [i  ] [j  ])
        );
            end
        end
    endgenerate
    
endmodule
