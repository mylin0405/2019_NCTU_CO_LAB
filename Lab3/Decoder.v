module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o , Branch_type , Branch_o , Jump_o , MemRead_o , MemWrite_o , MemtoReg_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[2-1:0] RegDst_o, MemtoReg_o ;
output          Branch_type , Branch_o , Jump_o , MemRead_o , MemWrite_o ; 
//Internal Signals
wire	[3-1:0] ALUOp_o;        // Either specifies the ALU operation to be performed or specifies that the operation should be determined from the function bits.
wire			ALUSrc_o;       // Selects the second source operand for the ALU. (rt, sign-extened)
wire			RegWrite_o;     // Enables a write to one of the registers.
wire	[2-1:0] RegDst_o;       // Determines how the destination register is specified.(rt, rd)
wire            Branch_o , Jump_o , MemRead_o , MemWrite_o ;
wire	[2-1:0] MemtoReg_o, Branch_type ;
//Main function
/*your code here*/

assign RegWrite_o = (instr_op_i == 6'b111111 ) ? 1 :   // R_type
                    (instr_op_i == 6'b110111 ) ? 1 :   // ADDI
					(instr_op_i == 6'b111011 ) ? 0 :   // BEQ
					(instr_op_i == 6'b110000 ) ? 1 :   // LUI
					(instr_op_i == 6'b100001 ) ? 1 :   // LW
					(instr_op_i == 6'b100011 ) ? 0 :   // SW
					(instr_op_i == 6'b100111 ) ? 1 :   // JAL
					(instr_op_i == 6'b100010 ) ? 0 :   // JUMP
                    (instr_op_i == 6'b100110 ) ? 0 :   // BNE
                    (instr_op_i == 6'b110001 ) ? 0 : 0 ;   //Others         

assign  RegDst_o =  (instr_op_i == 6'b111111 ) ? 1 :  // R_type                   
                    (instr_op_i == 6'b110111 ) ? 0 :  // ADDI
					(instr_op_i == 6'b111011 ) ? 0 :  // BEQ
					(instr_op_i == 6'b110000 ) ? 0 :  // LUI
					(instr_op_i == 6'b100001 ) ? 0 :  // LW
					(instr_op_i == 6'b100011 ) ? 0 :  // SW
					(instr_op_i == 6'b100010 ) ? 0 :  // JUMP
                    (instr_op_i == 6'b100101 ) ? 0 :  // BNE
                    (instr_op_i == 6'b100111 ) ? 2 :  // JAL
                    (instr_op_i == 6'b100110 ) ? 0 :  // BLT
                    (instr_op_i == 6'b110001 ) ? 0 :  // BGEZ
					(instr_op_i == 6'b101101 ) ? 0 : 0; // BNEZ            
					
assign ALUOp_o =    (instr_op_i == 6'b111111 ) ? 3'b010 : // R_type                   
                    (instr_op_i == 6'b110111 ) ? 3'b100 : // ADDI					
					(instr_op_i == 6'b110000 ) ? 3'b101 : // LUI
					(instr_op_i == 6'b100001 ) ? 3'b000 : // LW
					(instr_op_i == 6'b100011 ) ? 3'b000 : // SW
                    (instr_op_i == 6'b111011 ) ? 3'b001 : // BEQ
					(instr_op_i == 6'b100101 ) ? 3'b110 : // BNE
                    (instr_op_i == 6'b100110 ) ? 3'b110 :  // BLT
                   (instr_op_i == 6'b110001 ) ? 3'b110 :  // BGEZ   
				   (instr_op_i == 6'b101101 ) ? 3'b110 : 0 ; // BNEZ                     
					
assign ALUSrc_o =   (instr_op_i == 6'b111111 ) ? 0 :   // R_type                  
                    (instr_op_i == 6'b110111 ) ? 1 :   // ADDI
					(instr_op_i == 6'b111011 ) ? 0 :   // BEQ
					(instr_op_i == 6'b110000 ) ? 1 :   // LUI
					(instr_op_i == 6'b100001 ) ? 1 :   // LW
					(instr_op_i == 6'b100011 ) ? 1 :   // SW
					(instr_op_i == 6'b100010 ) ? 0 :   // JUMP
					(instr_op_i == 6'b100101 ) ? 0 :   // BNE
					(instr_op_i == 6'b100111 ) ? 0 : // JAL
                    (instr_op_i == 6'b100110 ) ? 0 : // BLT
                    (instr_op_i == 6'b110001 ) ? 0 :  // BGEZ
					(instr_op_i == 6'b101101 ) ? 0 : 0; // BNEZ  

assign Branch_type= (instr_op_i == 6'b111011 ) ? 0 : // BEQ
                    (instr_op_i == 6'b100101 ) ? 1 : // BNE 
                    (instr_op_i == 6'b101101 ) ? 1 : // BNEZ
					(instr_op_i == 6'b100110 ) ? 2 : // BLT 
                    (instr_op_i == 6'b110001 ) ? 0 : 0 ; // BGEZ 

assign Branch_o    =(instr_op_i == 6'b111011 ) ? 1 : // BEQ
                    (instr_op_i == 6'b100101 ) ? 1 : // BNE
                    (instr_op_i == 6'b100110 ) ? 1 : // BLT
                    (instr_op_i == 6'b110001 ) ? 1 : // BGEZ
					(instr_op_i == 6'b101101 ) ? 1 : 0; // BNEZ     

assign Jump_o =     (instr_op_i == 6'b100010 ) ? 1 : // JUMP
                    (instr_op_i == 6'b100111 ) ? 1 : 0 ; // JAL      
                    
assign MemRead_o =  (instr_op_i == 6'b111111 ) ? 0 : // R_type                   
                    (instr_op_i == 6'b110111 ) ? 0 : // ADDI
					(instr_op_i == 6'b111011 ) ? 0 : // BEQ
					(instr_op_i == 6'b110000 ) ? 0 : // LUI
					(instr_op_i == 6'b100001 ) ? 1 : // LW
					(instr_op_i == 6'b100011 ) ? 0 : // SW
					(instr_op_i == 6'b100010 ) ? 0 : // JUMP
                    (instr_op_i == 6'b100101 ) ? 0 : // BNE
                    (instr_op_i == 6'b100111 ) ? 0 : // JAL
                    (instr_op_i == 6'b100110 ) ? 0 : // BLT
                    (instr_op_i == 6'b110001 ) ? 0 : 0 ; // BGEZ      

assign MemWrite_o = (instr_op_i == 6'b111111 ) ? 0 : // R_type                   
                    (instr_op_i == 6'b110111 ) ? 0 : // ADDI
					(instr_op_i == 6'b111011 ) ? 0 : // BEQ
					(instr_op_i == 6'b110000 ) ? 0 : // LUI
					(instr_op_i == 6'b100001 ) ? 0 : // LW
					(instr_op_i == 6'b100011 ) ? 1 : // SW
					(instr_op_i == 6'b100010 ) ? 0 : // JUMP
                    (instr_op_i == 6'b100101 ) ? 0 : // BNE
                    (instr_op_i == 6'b100111 ) ? 0 : // JAL
                    (instr_op_i == 6'b100110 ) ? 0 : // BLT
                    (instr_op_i == 6'b110001 ) ? 0 : 0 ; // BGEZ      

assign MemtoReg_o = (instr_op_i == 6'b100111 ) ? 2 :          // JAL   
                    (instr_op_i == 6'b100001 ) ? 1 : 0 ;      // LW 
					
endmodule
   