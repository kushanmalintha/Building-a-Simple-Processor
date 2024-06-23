// Including bottom level modules
`include "alu.v"                   // Include ALU module
`include "reg_file.v"              // Include Register File module
`include "combinationalLogic.v"    // Include Combinational Logic module
`include "controlUnit.v"           // Include Control Unit module
`include "complimentNegNums.v"     // Include Twos Complement module
`include "mux.v"                   // Include MUX module
`include "adder.v"                 // Include Adder module

// Top module of the CPU with all the necessary bottom level modules included 
module cpu (PC, INSTRUCTION, CLK, RESET);
    // Input ports
    input [31:0] INSTRUCTION;       // 32-bit instruction input
    input CLK, RESET;               // Clock and Reset inputs
    
    // Output ports
    output reg [31:0] PC;           // 32-bit Program Counter output

    // ALU 
    wire [7:0]  ALURESULT;          // ALU result output
    wire [2:0] ALUOP;               // ALU operation input
    wire ZERO;                      // Flow selector (offset flow or normal flow)

    // Register 
    wire [2:0] READREG1, READREG2, WRITEREG;  // Register read and write control signals
    wire [7:0] REGOUT1, REGOUT2;    // Register data outputs
    wire WRITEENABLE;               // Register write enable signal

    // MUX1 
    wire [7:0] MUX1_OUT, NEGATIVE_NUM;  // MUX1 output and twos complement output
    wire MUX1SELECT;                // MUX1 select signal

    // MUX2 
    wire [7:0] MUX2_OUT ,IMMEDIATE; // MUX2 output and immediate value input
    wire MUX2SELECT;                // MUX2 select signal

    // FLOW_CONTROL
    wire JUMP, BRANCH, FLOWSELECT;  // Select the flow according to the given instructions

    // OFFSETADDER
    wire [31:0] TARGET;             // Target address
    wire [7:0] OFFSET;              // Off set for the j or beq instructions

    // PCADDER
    wire [31:0] PCADDER;              // Connection for pc+4

    // MUX3
    wire [31:0] MUX3_OUT;           // MUX3 output

    // SHIFT
    wire SHIFT_op;                  // Shift operation
    wire [2:0] AMOUNT;

    // Instantiation of CPU separate bottom modules
    combinationalLogic comLogic(INSTRUCTION, WRITEREG, READREG1, READREG2, IMMEDIATE, OFFSET, AMOUNT);  // Combinational Logic instantiation
    controlUnit control(INSTRUCTION, MUX1SELECT, MUX2SELECT, SHIFT_op, ALUOP, WRITEENABLE, JUMP, BRANCH);  // Control Unit instantiation
    reg_file register(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);  // Register File instantiation
    alu ALU(REGOUT1, MUX2_OUT, ALURESULT, ZERO, ALUOP, SHIFT_op, AMOUNT);                     // ALU instantiation
    twosComplement complement (REGOUT2, NEGATIVE_NUM);                      // Twos Complement instantiation
    mux mux1(REGOUT2, NEGATIVE_NUM, MUX1SELECT,MUX1_OUT);                   // MUX1 instantiation
    mux mux2(IMMEDIATE, MUX1_OUT, MUX2SELECT, MUX2_OUT);                    // MUX2 instantiation
    flowcontrol flow(JUMP, BRANCH, ZERO, FLOWSELECT);                       // Flow Control instantiation
    mux32bit mux3(PCADDER, TARGET, FLOWSELECT, MUX3_OUT);                     // MUX3 instantiation
    pcadder PCADD(PC, PCADDER);                                             // PC Adder instantiation
    offsetadder OFFSETADDER(PCADDER, OFFSET, TARGET);                         // Offset Adder instantiation
 
    
    // Clock always block
    always @(posedge CLK)
    begin
        if(RESET==1) begin
            #1 PC = 0;                   // Reset PC to 0
        end 
        else begin
            #1 PC = MUX3_OUT;           // Update PC based on MUX3 output
        end
    end
endmodule
