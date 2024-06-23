// Combinational logic module to decode the instruction
module combinationalLogic(INSTRUCTION, WRITEREG, READREG1, READREG2, IMMEDIATE, OFFSET, AMOUNT);
    input [31:0] INSTRUCTION; // Input instruction word
    output [7:0] IMMEDIATE; // Output immediate value
    output [2:0] WRITEREG; // Output destination register 
    output [2:0] READREG1; // Output first source register
    output [2:0] READREG2; // Output second source register
    output [7:0] OFFSET; // Output offset value
    output [2:0] AMOUNT;

    // Assign destination register from bits 18 to 16 of the instruction
    assign #1 WRITEREG = INSTRUCTION[18:16];

    // Assign first source register from bits 10 to 8 of the instruction
    assign #1 READREG1 = INSTRUCTION[10:8];

    // Assign second source register from bits 2 to 0 of the instruction
    assign #1 READREG2 = INSTRUCTION[2:0];

    // Assign immediate value from bits 7 to 0 of the instruction
    assign #1 IMMEDIATE = INSTRUCTION[7:0];

    // Assign offset value from bits 23 to 16 of the instruction
    assign #1 OFFSET = INSTRUCTION[23:16];

    assign #1 AMOUNT = INSTRUCTION[2:0];

endmodule