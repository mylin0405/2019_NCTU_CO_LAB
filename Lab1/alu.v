`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// 0616058_0617052
// Company:
// Engineer:
//
// Create Date:    15:15:11 03/21/2019
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		   //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;
reg		a_invert;
reg 	        b_invert;
reg    [2-1:0]	operation;
wire		set;
wire   [31:0]	cout_;
wire   [31:0]	result_n;


												 	
always @(*) begin
    if(rst_n == 1) begin
		case(ALU_control)
			4'b0000:begin         //and
				a_invert <= 0;
				b_invert <= 0;
				operation <= 2'b00;end
			
			4'b0001:begin 		  //or
				a_invert <= 0;
				b_invert <= 0;
				operation <= 2'b01;end
			
			4'b0010:begin		  //add
				a_invert <= 0;
				b_invert <= 0;
				operation <= 2'b10;end
				
			4'b0110:begin		  //sub
				a_invert  <= 0;
				b_invert  <= 1;
				operation <= 2'b10;end
			
			4'b1100:begin		  //nor
				a_invert <= 1;
				b_invert <= 1;
				operation <= 2'b00;end
			
			4'b1101:begin		  //nand
				a_invert <= 1;
				b_invert <= 1;
				operation <= 2'b01;end
			
			4'b0111:begin         //slt
				a_invert <= 0;
				b_invert <= 1;
				operation <= 2'b11;end
			
			default:;
		endcase	
	end
end


alu_top alu0(.src1(src1[0]), .src2(src2[0]), .less(set), .A_invert(a_invert), .B_invert(b_invert), .cin(a_invert ^ b_invert),
			 .operation(operation), .result(result_n[0]), .cout(cout_[0]));
alu_top alu1(.src1(src1[1]), .src2(src2[1]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[0]), 
			 .operation(operation), .result(result_n[1]), .cout(cout_[1]));
alu_top alu2(.src1(src1[2]), .src2(src2[2]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[1]), 
			 .operation(operation), .result(result_n[2]), .cout(cout_[2]));
alu_top alu3(.src1(src1[3]), .src2(src2[3]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[2]), 
			 .operation(operation), .result(result_n[3]), .cout(cout_[3]));
alu_top alu4(.src1(src1[4]), .src2(src2[4]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[3]), 
			 .operation(operation), .result(result_n[4]), .cout(cout_[4]));
alu_top alu5(.src1(src1[5]), .src2(src2[5]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[4]), 
			 .operation(operation), .result(result_n[5]), .cout(cout_[5]));
alu_top alu6(.src1(src1[6]), .src2(src2[6]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[5]), 
			 .operation(operation), .result(result_n[6]), .cout(cout_[6]));
alu_top alu7(.src1(src1[7]), .src2(src2[7]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[6]), 
			 .operation(operation), .result(result_n[7]), .cout(cout_[7]));
alu_top alu8(.src1(src1[8]), .src2(src2[8]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[7]), 
			 .operation(operation), .result(result_n[8]), .cout(cout_[8]));
alu_top alu9(.src1(src1[9]), .src2(src2[9]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[8]), 
			 .operation(operation), .result(result_n[9]), .cout(cout_[9]));
alu_top alu10(.src1(src1[10]), .src2(src2[10]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[9]), 
			 .operation(operation), .result(result_n[10]), .cout(cout_[10]));
alu_top alu11(.src1(src1[11]), .src2(src2[11]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[10]), 
			 .operation(operation), .result(result_n[11]), .cout(cout_[11]));
alu_top alu12(.src1(src1[12]), .src2(src2[12]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[11]), 
			 .operation(operation), .result(result_n[12]), .cout(cout_[12]));
alu_top alu13(.src1(src1[13]), .src2(src2[13]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[12]), 
			 .operation(operation), .result(result_n[13]), .cout(cout_[13]));
alu_top alu14(.src1(src1[14]), .src2(src2[14]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[13]), 
			 .operation(operation), .result(result_n[14]), .cout(cout_[14]));
alu_top alu15(.src1(src1[15]), .src2(src2[15]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[14]), 
			 .operation(operation), .result(result_n[15]), .cout(cout_[15]));
alu_top alu16(.src1(src1[16]), .src2(src2[16]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[15]), 
			 .operation(operation), .result(result_n[16]), .cout(cout_[16]));
alu_top alu17(.src1(src1[17]), .src2(src2[17]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[16]), 
			 .operation(operation), .result(result_n[17]), .cout(cout_[17]));
alu_top alu18(.src1(src1[18]), .src2(src2[18]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[17]), 
			 .operation(operation), .result(result_n[18]), .cout(cout_[18]));
alu_top alu19(.src1(src1[19]), .src2(src2[19]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[18]), 
			 .operation(operation), .result(result_n[19]), .cout(cout_[19]));
alu_top alu20(.src1(src1[20]), .src2(src2[20]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[19]), 
			 .operation(operation), .result(result_n[20]), .cout(cout_[20]));
alu_top alu21(.src1(src1[21]), .src2(src2[21]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[20]), 
			 .operation(operation), .result(result_n[21]), .cout(cout_[21]));
alu_top alu22(.src1(src1[22]), .src2(src2[22]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[21]), 
			 .operation(operation), .result(result_n[22]), .cout(cout_[22]));
alu_top alu23(.src1(src1[23]), .src2(src2[23]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[22]), 
			 .operation(operation), .result(result_n[23]), .cout(cout_[23]));
alu_top alu24(.src1(src1[24]), .src2(src2[24]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[23]), 
			 .operation(operation), .result(result_n[24]), .cout(cout_[24]));
alu_top alu25(.src1(src1[25]), .src2(src2[25]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[24]), 
			 .operation(operation), .result(result_n[25]), .cout(cout_[25]));
alu_top alu26(.src1(src1[26]), .src2(src2[26]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[25]), 
			 .operation(operation), .result(result_n[26]), .cout(cout_[26]));
alu_top alu27(.src1(src1[27]), .src2(src2[27]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[26]), 
			 .operation(operation), .result(result_n[27]), .cout(cout_[27]));
alu_top alu28(.src1(src1[28]), .src2(src2[28]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[27]), 
			 .operation(operation), .result(result_n[28]), .cout(cout_[28]));
alu_top alu29(.src1(src1[29]), .src2(src2[29]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[28]), 
			 .operation(operation), .result(result_n[29]), .cout(cout_[29]));
alu_top alu30(.src1(src1[30]), .src2(src2[30]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[29]), 
			 .operation(operation), .result(result_n[30]), .cout(cout_[30]));
alu_top alu31(.src1(src1[31]), .src2(src2[31]), .less(1'b0), .A_invert(a_invert), .B_invert(b_invert), .cin(cout_[30]), 
			 .operation(operation), .result(result_n[31]), .cout(cout_[31])/*bonus layer*/);

assign set = (src1[31]^(~src2[31])^cout_[30]);

always @(*) begin
	cout = cout_;
	result = result_n ;
	zero = (result == 0) ? 1 : 0 ;
	overflow = ((src1[31]&(src2[31]^b_invert)) ^ result[31]) & (a_invert^b_invert) & ~(src1[31]^src2[31]);
end
/*assign	set = (cmp==3'b000) ? (s1 ^ s2 ^ cin) : //set less than <
					(cmp==3'b001) ? ~( (s1 ^ s2 ^ cin) | equal) : //set great than >
					(cmp==3'b010) ? ((s1 ^ s2 ^ cin) | equal) : //set less equal <=
					(cmp==3'b011) ? (~ (s1 ^ s2 ^ cin)) ://set great equal >=
					(cmp==3'b110) ? (equal) ://set equal ==
					(cmp==3'b100) ? (~equal) : 0;//set not equal !=

*/		 
endmodule
