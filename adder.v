// Module for adding 4 to the Program Counter (PC)
module pcadder(PC, PCADDER);
    // Input port for the Program Counter
    input [31:0] PC;

    // Output port for the Program Counter with 4 added
    output [31:0] PCADDER;
    
    // Assigning the output PCADD with a delay of one time unit
    assign #1 PCADDER = PC + 4; 

endmodule


/* OFFSET Adder module to support jump and branch functions */
module offsetadder(PCADDER, OFFSET, TARGET);
    // Input port for the Program Counter
    input [31:0] PCADDER;
    // Input port for the Offset
    input [7:0] OFFSET;
    // Output port for the Target address
    output [31:0] TARGET;

    // Wire for storing sign extension bits
    wire [21:0] signBits;

    // Sign extension: extend the sign of OFFSET to 22 bits
    assign signBits = {22{OFFSET[7]}};

    // Calculate the target address by adding PCADD and OFFSET with a delay of two time units
    assign #2 TARGET = PCADDER + {signBits, OFFSET, 2'b0};

endmodule