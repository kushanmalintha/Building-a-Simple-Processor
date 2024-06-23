module controlUnit(INSTRUCTION, MUX1, MUX2, SHIFT_op, ALUOP, WRITEENABLE, JUMP, BRANCH);
    input [31:0] INSTRUCTION;
    reg [7:0] OPCODE;
    output reg MUX1, MUX2, SHIFT_op, WRITEENABLE, JUMP, BRANCH;
    output reg [2:0] ALUOP;
    
    always @(INSTRUCTION)
    begin

        OPCODE = INSTRUCTION[31:24];

        case(OPCODE)
            //call loadi
            8'b00000000 : begin
                assign WRITEENABLE = 1;   
                assign MUX1 = 0;   //Selecting the positive number
                assign MUX2 = 0;   //Selecting the immediate operand
                assign ALUOP = 3'b000;  //selecting the FORWARD operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //call mov
            8'b00000001 : begin
                assign WRITEENABLE = 1; 
                assign MUX1 = 0;   //Selecting the positive number
                assign MUX2 = 1;   //Selecting the output of the mux1
                assign ALUOP = 3'b000;//selecting the FORWARD operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //call add
            8'b00000010 : begin
                assign WRITEENABLE = 1;   
                assign MUX1= 0;    //Selecting the positive number
                assign MUX2 = 1;   //Selecting the output of the mux1
                assign ALUOP = 3'b001;  //selecting the ADD operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //call sub
            8'b00000011 : begin
                assign WRITEENABLE = 1;   
                assign MUX1 = 1;   //Selecting the negative number
                assign MUX2 = 1;   //Selecting the output of the mux1
                assign ALUOP = 3'b001;//selecting the ADD operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //call and
            8'b00000100 : begin
                assign WRITEENABLE = 1;   
                assign MUX1 = 0;   //Selecting the positive number
                assign MUX2 = 1;   //Selecting the output of the mux1
                assign ALUOP = 3'b010;//selecting the AND operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //call or
            8'b00000101 : begin
                assign WRITEENABLE = 1;   
                assign MUX1= 0;    //Selecting the positive number
                assign MUX2 = 1;   //Selecting the output of the mux1
                assign ALUOP = 3'b011;  //selecting the OR operation from ALU
                assign JUMP = 0;
                assign BRANCH = 0;
            end
            //jump call
            8'b00000110 : begin
                assign WRITEENABLE = 0;
                assign JUMP = 1;
                assign BRANCH = 0;
            end
            //beq call
            8'b00000111 : begin
                assign WRITEENABLE = 0;
                assign MUX1 = 1; //Selecting the negative number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign ALUOP = 3'b001; //Selecting the ADD operation from ALU
                assign BRANCH = 1;
                assign JUMP = 0;
            end
            //multiplication call
            8'b00001000 : begin
                assign WRITEENABLE = 1;
                assign MUX1 = 0; //Selecting the positive number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign ALUOP = 3'b100; //Selecting the MUL operation from ALU
                assign BRANCH = 0;
                assign JUMP = 0;
            end
            //logical shift left call
            8'b00001001 : begin
                assign WRITEENABLE = 1;
                assign MUX1 = 0; //Selecting the positive number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign SHIFT_op = 1;
                assign ALUOP = 3'b101; //Selecting the SLL operation from ALU
                assign BRANCH = 0;
                assign JUMP = 0;
            end
            //logical shift right call
            8'b00001010 : begin
                assign WRITEENABLE = 1;
                assign MUX1 = 0; //Selecting the positive number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign SHIFT_op = 0;
                assign ALUOP = 3'b101; //Selecting the SRL operation from ALU
                assign BRANCH = 0;
                assign JUMP = 0;
            end
            //bne call
            8'b00001011 : begin
                assign WRITEENABLE = 0;
                assign MUX1 = 1; //Selecting the negative number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign ALUOP = 3'b001; //Selecting the ADD operation from ALU
                assign BRANCH = 1;
                assign JUMP = 1;
            end
            //arithmetic shift right call
            8'b00001100 : begin
                assign WRITEENABLE = 1;
                assign MUX1 = 0; //Selecting the positive number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign ALUOP = 3'b110; //Selecting the SRA operation from ALU
                assign BRANCH = 0;
                assign JUMP = 0;
            end
            //rotate call
            8'b00001101 : begin
                assign WRITEENABLE = 1;
                assign MUX1 = 0; //Selecting the positive number
                assign MUX2 = 1; //selecting the output of the mux 1
                assign ALUOP = 3'b111; //Selecting the SRA operation from ALU
                assign BRANCH = 0;
                assign JUMP = 0;
            end
        endcase
    end

endmodule

// Control the flow(offset flow or normal flow)
// jump and beq has offset flow while others has normal 
// bne has offset flow
module flowcontrol(JUMP, BRANCH, ZERO, FLOWSELECT);
    input JUMP, BRANCH, ZERO; //input ports declaration
    output FLOWSELECT; //output port declaration
    assign FLOWSELECT = JUMP ^ (BRANCH & ZERO);
endmodule